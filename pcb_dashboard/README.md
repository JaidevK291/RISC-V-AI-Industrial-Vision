# PCB Defect Detection Dashboard

## Files
- `app.py`: Streamlit dashboard
- `requirements.txt`: Python dependencies
- `pcb_model_int8.tflite`: copy your trained model into this folder

## Run locally
1. Put `pcb_model_int8.tflite` next to `app.py`.
2. Open a terminal in this folder.
3. Install dependencies:
   ```bash
   python -m pip install -r requirements.txt
   ```
4. Start the dashboard:
   ```bash
   streamlit run app.py
   ```

The browser will open the dashboard. Upload a PCB image to classify it.

## Important model assumption
The app assumes the model was trained with `image_dataset_from_directory` where class order was
`['DEFECTED', 'NORMAL']` and the final sigmoid output represents class index 1 (`NORMAL`).
It preprocesses input as grayscale, 256x256, raw pixel range 0–255 before model input quantization.
If your exported model's input quantization details or training preprocessing differ, adjust
`preprocess_image` / `run_inference` accordingly.
