`[trainedModel, validationRMSE] = trainRegressionModel(trainingData)`
Returns a trained regression model and its RMSE. Use the code to
automate training the same model with new data.

  Input:
      `trainingData`: A table containing the predictor and response
       columns.

  Output:
     `trainedModel`: A struct containing the trained regression model. The
       struct contains various fields with information about the trained
       model.\
      `trainedModel.predictFcn`: A function to make predictions on new data.\
      `validationRMSE`: A double containing the RMSE.

For example, to retrain a regression model trained with the original data
set T, enter:
   `[trainedModel, validationRMSE] = trainRegressionModel(T)`

To make predictions with the returned `trainedModel` on new data T2, use

   `yfit = trainedModel.predictFcn(T2)`

T2 must be a table containing at least the same predictor columns as used
during training. For details, enter:

   `trainedModel.HowToPredict`
