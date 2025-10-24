# Aeroscope
AeroScope was born out of a passion for Formula 1 engineering and curiosity about how teams design their cars differently to chase every millisecond of performance. Watching F1 races, we noticed how even small aerodynamic updates could completely change a car’s speed — and that inspired us to build a tool that could see those differences scientifically.

Using MATLAB, we developed AeroScope: a visual intelligence system that compares two F1 cars (like the Haas VF25 and Williams FW47) and identifies aerodynamic design differences using image processing. The system calculates which regions — front wing, sidepod, rear wing, or floor — have the biggest variation, and even predicts which car has a more efficient aerodynamic profile.

How We Built It:
We used MATLAB’s image processing toolbox to handle high-resolution side-view car images, filtered out noise, and computed pixel-level differences. Then, we classified those differences into aerodynamic zones and visualized them with heatmaps and bar charts. Finally, we introduced a “Speed Efficiency Index” to estimate which car might perform better aerodynamically.

What We Learned:
This project taught us how computer vision and engineering can work together to analyze performance without even touching a wind tunnel. We learned about data normalization, thresholding, and aerodynamic concepts like downforce, drag, and floor effect — and how small visual differences can represent huge performance changes on track.

Challenges Faced:
The hardest part was cleaning the image data — shadows, reflections, and tires often caused false differences. We also had to fine-tune the detection threshold so the model focused only on relevant body parts. Balancing accuracy with speed in MATLAB under a strict hackathon time limit was another challenge, but also what made it exciting.

In the end, AeroScope isn’t just a code project — it’s a glimpse into the future of digital motorsport analysis, where AI and engineering meet to make race cars faster, smarter, and more efficient.
