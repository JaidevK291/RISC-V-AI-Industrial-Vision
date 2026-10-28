"""Benchmark the project's INT8 TFLite model on the current computer.

Run from the folder containing this script and pcb_model_int8.tflite:
    python benchmark_int8.py path\to\pcb_image.jpg
Optional number of measured runs:
    python benchmark_int8.py path\to\pcb_image.jpg --runs 200
"""
import argparse
import platform
import statistics
import time
from pathlib import Path

import numpy as np
from PIL import Image, ImageOps

try:
    from ai_edge_litert.interpreter import Interpreter
    runtime = "LiteRT"
except ImportError:
    try:
        from tflite_runtime.interpreter import Interpreter
        runtime = "TFLite Runtime"
    except ImportError:
        import tensorflow as tf
        Interpreter = tf.lite.Interpreter
        runtime = "TensorFlow Lite"

IMG_SIZE = (256, 256)


def preprocess(path):
    start = time.perf_counter()
    image = Image.open(path)
    image = ImageOps.grayscale(image).resize(IMG_SIZE, Image.Resampling.BILINEAR)
    arr = np.asarray(image, dtype=np.float32)[None, ..., None]
    return arr, (time.perf_counter() - start) * 1000


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("image", help="Path to a representative PCB image")
    parser.add_argument("--runs", type=int, default=200, help="Measured inference runs (default: 200)")
    args = parser.parse_args()

    model_path = Path(__file__).with_name("pcb_model_int8.tflite")
    image_path = Path(args.image)
    if not model_path.exists():
        raise SystemExit(f"Model not found: {model_path}\nPut pcb_model_int8.tflite beside this script.")
    if not image_path.exists():
        raise SystemExit(f"Image not found: {image_path}")
    if args.runs < 1:
        raise SystemExit("--runs must be at least 1")

    interpreter = Interpreter(model_path=str(model_path))
    interpreter.allocate_tensors()
    inp = interpreter.get_input_details()[0]
    out = interpreter.get_output_details()[0]

    image_batch, preprocess_ms = preprocess(image_path)
    scale, zero = inp.get("quantization", (0.0, 0))
    if np.issubdtype(inp["dtype"], np.integer):
        if scale and scale > 0:
            input_tensor = np.clip(np.round(image_batch / scale + zero),
                                   np.iinfo(inp["dtype"]).min,
                                   np.iinfo(inp["dtype"]).max).astype(inp["dtype"])
        else:
            input_tensor = np.clip(np.round(image_batch), 0, 255).astype(inp["dtype"])
    else:
        input_tensor = image_batch.astype(inp["dtype"])

    def invoke_once():
        interpreter.set_tensor(inp["index"], input_tensor)
        interpreter.invoke()
        return interpreter.get_tensor(out["index"])

    # Warm-up runs are excluded from the measurements.
    for _ in range(10):
        invoke_once()

    times = []
    end_to_end = []
    for _ in range(args.runs):
        t0 = time.perf_counter()
        invoke_once()
        times.append((time.perf_counter() - t0) * 1000)

        t0 = time.perf_counter()
        fresh_batch, _ = preprocess(image_path)
        if np.issubdtype(inp["dtype"], np.integer):
            if scale and scale > 0:
                fresh_input = np.clip(np.round(fresh_batch / scale + zero),
                                      np.iinfo(inp["dtype"]).min,
                                      np.iinfo(inp["dtype"]).max).astype(inp["dtype"])
            else:
                fresh_input = np.clip(np.round(fresh_batch), 0, 255).astype(inp["dtype"])
        else:
            fresh_input = fresh_batch.astype(inp["dtype"])
        interpreter.set_tensor(inp["index"], fresh_input)
        interpreter.invoke()
        end_to_end.append((time.perf_counter() - t0) * 1000)

    times_sorted = sorted(times)
    p95 = times_sorted[min(len(times_sorted) - 1, int(np.ceil(0.95 * len(times_sorted))) - 1)]
    mean_ms = statistics.mean(times)
    median_ms = statistics.median(times)
    e2e_mean = statistics.mean(end_to_end)

    print("PCB INT8 model benchmark")
    print("------------------------")
    print(f"Runtime: {runtime}")
    print(f"Computer: {platform.platform()} | Python {platform.python_version()}")
    print(f"Model: {model_path} ({model_path.stat().st_size / 1024:.2f} KiB)")
    print(f"Input image: {image_path} -> grayscale {IMG_SIZE[0]}x{IMG_SIZE[1]}")
    print(f"Measured runs: {args.runs} (plus 10 warm-up runs)")
    print(f"Preprocessing time, one initial run: {preprocess_ms:.3f} ms")
    print(f"Inference mean: {mean_ms:.3f} ms/image")
    print(f"Inference median: {median_ms:.3f} ms/image")
    print(f"Inference p95: {p95:.3f} ms/image")
    print(f"Inference-only throughput: {1000 / mean_ms:.2f} images/second (approx. FPS)")
    print(f"Preprocessing + inference mean: {e2e_mean:.3f} ms/image")
    print(f"Preprocessing + inference throughput: {1000 / e2e_mean:.2f} images/second (approx. FPS)")
    print("Note: results apply to this computer/runtime and exclude browser/network overhead.")


if __name__ == "__main__":
    main()
