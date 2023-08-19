function [trainedModel, validationRMSE] = trainRegressionModel(trainingData)

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'code', 'strength', 'size', 'start', 'api_code', 'api_batch', 'smcc_batch', 'lactose_batch', 'starch_batch', 'api_water', 'api_total_impurities', 'api_l_impurity', 'api_content', 'api_ps01', 'api_ps05', 'api_ps1', 'api_ps09', 'lactose_water', 'lactose_sieve0045', 'lactose_sieve015', 'lactose_sieve025', 'smcc_water', 'smcc_td', 'smcc_bd', 'smcc_ps01', 'smcc_ps05', 'smcc_ps09', 'starch_ph', 'starch_water'};
predictors = inputTable(:, predictorNames);
response = inputTable.dissolution_av;
isCategoricalPredictor = [true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a regression model
% This code specifies all the model options and trains the model.
responseScale = iqr(response);
if ~isfinite(responseScale) || responseScale == 0.0
    responseScale = 1.0;
end
boxConstraint = responseScale/1.349;
epsilon = responseScale/13.49;
regressionSVM = fitrsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', boxConstraint, ...
    'Epsilon', epsilon, ...
    'Standardize', true);

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(regressionSVM, x);
trainedModel.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedModel.RequiredVariables = {'api_batch', 'api_code', 'api_content', 'api_l_impurity', 'api_ps01', 'api_ps05', 'api_ps09', 'api_ps1', 'api_total_impurities', 'api_water', 'code', 'lactose_batch', 'lactose_sieve0045', 'lactose_sieve015', 'lactose_sieve025', 'lactose_water', 'size', 'smcc_batch', 'smcc_bd', 'smcc_ps01', 'smcc_ps05', 'smcc_ps09', 'smcc_td', 'smcc_water', 'starch_batch', 'starch_ph', 'starch_water', 'start', 'strength'};
trainedModel.RegressionSVM = regressionSVM;
trainedModel.About = 'This struct is a trained model exported from Regression Learner R2022b.';
trainedModel.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'code', 'strength', 'size', 'start', 'api_code', 'api_batch', 'smcc_batch', 'lactose_batch', 'starch_batch', 'api_water', 'api_total_impurities', 'api_l_impurity', 'api_content', 'api_ps01', 'api_ps05', 'api_ps1', 'api_ps09', 'lactose_water', 'lactose_sieve0045', 'lactose_sieve015', 'lactose_sieve025', 'smcc_water', 'smcc_td', 'smcc_bd', 'smcc_ps01', 'smcc_ps05', 'smcc_ps09', 'starch_ph', 'starch_water'};
predictors = inputTable(:, predictorNames);
response = inputTable.dissolution_av;
isCategoricalPredictor = [true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
KFolds = 5;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% Initialize the predictions to the proper sizes
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;

    % Train a regression model
    % This code specifies all the model options and trains the model.
    responseScale = iqr(trainingResponse);
    if ~isfinite(responseScale) || responseScale == 0.0
        responseScale = 1.0;
    end
    boxConstraint = responseScale/1.349;
    epsilon = responseScale/13.49;
    regressionSVM = fitrsvm(...
        trainingPredictors, ...
        trainingResponse, ...
        'KernelFunction', 'linear', ...
        'PolynomialOrder', [], ...
        'KernelScale', 'auto', ...
        'BoxConstraint', boxConstraint, ...
        'Epsilon', epsilon, ...
        'Standardize', true);

    % Create the result struct with predict function
    svmPredictFcn = @(x) predict(regressionSVM, x);
    validationPredictFcn = @(x) svmPredictFcn(x);

    % Add additional fields to the result struct

    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);

    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% Compute validation RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
