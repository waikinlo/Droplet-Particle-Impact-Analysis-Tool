# Droplet-Particle-Impact-Analysis-Tool
MATLAB tool for dynamic analysis of droplet impact 

This is the code repository for the paper: "Liquid droplet mops" by Lo et al.

Usage:
This code analyzes high-speed videos of a needle-generated droplet impacting a particle. Two entry scripts are provided depending on whether the needle is visible in the impact video.

Requirements:
- MATLAB R2023a (recommended; the code was developed and tested with this version)

Installation:
1. Download and install MATLAB R2023a from MathWorks
2. Download this repository (or the provided ZIP package) and extract it to a local folder
3. Open MATLAB and set the extracted folder as the Current Folder (or add it to the MATLAB path)

Scenarios:
Case 1: Low impact height (needle visible in the impact video)
Use T01.m when the impact video contains the needle (commonly observed at low impact heights)
1. Open MATLAB and run T01.m
2. When prompted, select and upload the "droplet impact particle" video
3. Next step, when prompted, select and upload the "scale bar" video
  (The scale video is used to calibrate the pixel-to-length conversion and ensure correct physical measurements.)
4. The pipeline will run automatically and perform the dynamic analysis
5. After completion, results are available in the Data output (results folder/file), including:
   - droplet size
   - particle size
   - impact velocity
   - lifting height
   - defined regions/classes of impact outcomes

Case 2: Higher impact height (needle not visible in the impact video)
Use T02.m when the impact video does not contain the needle (commonly observed at higher impact heights)
1. Open MATLAB and run T02.m
2. When prompted, select and upload the "droplet impact particle" video
3. Next step, when prompted, select and upload the "scale bar" video
  (The scale video is used to calibrate the pixel-to-length conversion and ensure correct physical measurements.)
4. The pipeline will run automatically and perform the dynamic analysis
5. After completion, results are available in the Data output (results folder/file) as described above

Notes (optional but recommended for clarity/accessibility)
- Ensure that the impact video and the scale video are recorded under comparable imaging settings (e.g., same magnification and camera setup), so that the calibration is valid
- If you are unsure whether the needle is visible, open the first few frames of the impact video:
  - needle visible → run T01.m
  - needle not visible → run T02.m
