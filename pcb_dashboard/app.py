import os
from pathlib import Path

import numpy as np
import streamlit as st
from PIL import Image, ImageOps

# Prefer the lightweight TFLite runtime when available; otherwise use TensorFlow.
try:
    from ai_edge_litert.interpreter import Interpreter
    RUNTIME_NAME = "LiteRT"
except ImportError:
    try:
        from tflite_runtime.interpreter import Interpreter
        RUNTIME_NAME = "TFLite Runtime"
    except ImportError:
        import tensorflow as tf
        Interpreter = tf.lite.Interpreter
        RUNTIME_NAME = "TensorFlow Lite"

MODEL_PATH = Path(__file__).parent / "pcb_model_int8.tflite"
IMG_SIZE = (256, 256)

st.set_page_config(
    page_title="PCB Defect Detection",
    page_icon="🔎",
    layout="wide",
)

st.title("PCB Defect Detection")
st.caption("CNN-powered binary classification • NORMAL vs DEFECTED")
st.write(
    "Upload a PCB image to classify it using the trained INT8 TensorFlow Lite model. "
    "This is a decision-support demo; verify predictions before making production decisions."
)

with st.sidebar:
    st.header("Model information")
    st.metric("INT8 model size", "583.32 KB")
    st.metric("Reported test accuracy", "92.04%")
    st.write("Input: 256 × 256 grayscale image")
    st.write("Classes: DEFECTED / NORMAL")
    st.caption(f"Inference runtime: {RUNTIME_NAME}")
    st.divider()
    st.warning(
        "Reported accuracy is from the project's held-out test set (452 images), "
        "not a guarantee for every new camera or manufacturing line."
    )

@st.cache_resource
def load_interpreter(model_path: str, model_mtime: float):
    interpreter = Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

def preprocess_image(pil_image: Image.Image):
    # Match training: grayscale, resize to 256×256, raw pixel values 0–255.
    image = ImageOps.grayscale(pil_image)
    image = image.resize(IMG_SIZE, Image.Resampling.BILINEAR)
    arr = np.asarray(image, dtype=np.float32)
    return arr[np.newaxis, ..., np.newaxis], image

def run_inference(interpreter, image_batch):
    input_info = interpreter.get_input_details()[0]
    output_info = interpreter.get_output_details()[0]

    input_scale, input_zero = input_info.get("quantization", (0.0, 0))
    input_dtype = input_info["dtype"]

    # The model's input tensor is uint8. Quantize only if the tensor is integer.
    if np.issubdtype(input_dtype, np.integer):
        if input_scale and input_scale > 0:
            quantized = np.round(image_batch / input_scale + input_zero)
        else:
            # For this model, the input is expected to represent raw pixels 0–255.
            quantized = np.round(image_batch)
        limits = np.iinfo(input_dtype)
        input_batch = np.clip(quantized, limits.min, limits.max).astype(input_dtype)
    else:
        input_batch = image_batch.astype(input_dtype)

    interpreter.set_tensor(input_info["index"], input_batch)
    interpreter.invoke()
    raw_output = interpreter.get_tensor(output_info["index"]).astype(np.float32)

    output_scale, output_zero = output_info.get("quantization", (0.0, 0))
    if np.issubdtype(output_info["dtype"], np.integer) and output_scale and output_scale > 0:
        output = (raw_output - output_zero) * output_scale
    else:
        output = raw_output

    # Keras class order was ['DEFECTED', 'NORMAL']; sigmoid output is P(class index 1) = P(NORMAL).
    p_normal = float(np.clip(output.reshape(-1)[0], 0.0, 1.0))
    p_defected = 1.0 - p_normal
    label = "NORMAL" if p_normal >= 0.5 else "DEFECTED"
    confidence = max(p_normal, p_defected)
    return label, confidence, p_defected, p_normal

if not MODEL_PATH.exists():
    st.error("Model file not found.")
    st.markdown(
        "Place **`pcb_model_int8.tflite`** in the same folder as `app.py`, then restart the app."
    )
    st.code(
        "pcb_dashboard/\n"
        "├── app.py\n"
        "├── requirements.txt\n"
        "└── pcb_model_int8.tflite"
    )
    st.stop()

try:
    interpreter = load_interpreter(str(MODEL_PATH), MODEL_PATH.stat().st_mtime)
except Exception as exc:
    st.error(f"Could not load the TFLite model: {exc}")
    st.stop()

uploaded_file = st.file_uploader(
    "Upload a PCB image",
    type=["png", "jpg", "jpeg", "bmp", "tif", "tiff"],
    help="Use a clear image similar to the images used to train the model.",
)

if uploaded_file is not None:
    try:
        original = Image.open(uploaded_file).convert("RGB")
    except Exception:
        st.error("This image could not be opened. Please upload a valid image file.")
        st.stop()

    left, right = st.columns([1, 1], gap="large")
    with left:
        st.subheader("Uploaded PCB")
        st.image(original, use_container_width=True)
        st.caption(f"Original image dimensions: {original.width} × {original.height}")

    with st.spinner("Analyzing PCB image..."):
        try:
            image_batch, processed_image = preprocess_image(original)
            label, confidence, p_defected, p_normal = run_inference(
                interpreter, image_batch
            )
        except Exception as exc:
            st.error(f"Inference failed: {exc}")
            st.stop()

    with right:
        st.subheader("Prediction")
        if label == "DEFECTED":
            st.error("⚠️ DEFECTED")
            st.write("The model predicts that this PCB image belongs to the DEFECTED class.")
        else:
            st.success("✅ NORMAL")
            st.write("The model predicts that this PCB image belongs to the NORMAL class.")

        st.metric("Prediction confidence", f"{confidence * 100:.2f}%")
        st.progress(int(round(confidence * 100)))
        st.image(processed_image, caption="Model input: grayscale, resized to 256 × 256", width=256)

    st.subheader("Class scores")
    score_col1, score_col2 = st.columns(2)
    with score_col1:
        st.metric("DEFECTED score", f"{p_defected * 100:.2f}%")
        st.progress(int(round(p_defected * 100)))
    with score_col2:
        st.metric("NORMAL score", f"{p_normal * 100:.2f}%")
        st.progress(int(round(p_normal * 100)))

    st.caption(
        "Scores are model outputs, not calibrated probabilities. The prediction is based on a 0.5 threshold."
    )
else:
    st.info("Upload an image above to run a prediction.")
    st.subheader("How to use")
    st.markdown(
        "1. Select a PCB image.\n"
        "2. Review the predicted class and confidence.\n"
        "3. Use the result as a screening aid and confirm uncertain or high-risk cases manually."
    )

st.divider()
st.caption("PCB Defect Detection • Custom CNN converted to INT8 TensorFlow Lite")
