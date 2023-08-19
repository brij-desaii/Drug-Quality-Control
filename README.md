# Drug Quality Control using Machine Learning

This project was built as our submission to the Flipkart GRiD 5.0 Health+ Hackathon.

The `Application` directory contains the application to be used by manufacturers. The ML models are implemented in a Jupyter Notebook and the UI was built using Anvil. 

The `Dataset` directory contains the dataset that we have cleaned and pre-processed (taken from Žagar, J., & Mihelič, J. (2022). Big data collection in pharmaceutical manufacturing and its use for product quality predictions. Scientific Data, 9(1), 1-11. https://doi.org/10.1038/s41597-022-01203-x).

The `MATLAB_Models` directory contains the best models for each of the parameters as discussed in the presentation slides.

The `Plots` directory has the test data prediction plots of the MATLAB models.

## Steps to Run

1. Open the `Application/notebook.ipynb` file in Google Colab and upload the dataset present at `Dataset/data.csv`.

2. Install the `anvil-uplink` library by running the first cell of the notebook.

```bash
!pip install anvil-uplink
```
  After this colab will prompt you to restart the runtime. Restart it and comment the above line.

3. In the Menu bar, click on `Runtime` and then click on `Run all` to run all the remaining cells. This will import the dataset, train the models and expose the runtime to anvil.

4. Visit the following URL on any browser of your choice to start making predictions!
```bash
https://efficacy-predictor.anvil.app/
```
  Enter the required fields and click on the `PREDICT` button. The results should be displayed on the screen.

5. To contribute data to the ML model scroll down to the `Upload Final Data` section, fill out the displayed fields and click on the `UPLOAD` button. 
