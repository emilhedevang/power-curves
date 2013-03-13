Power Curves
============

Wind turbine power curve analysis

The purpose of this repository is to provide code, papers, and sample data for power curve analyses.

Bootstrapping Power Curves
==========================

The following is an outline of an outline of a paper still to be written.

Data
----
* Mean hubheight wind speed, `U`.
* Shear exponent, `alpha`.
* Turbulence intensity, `I`.
* Mean power, `P`.
* Standard deviation of power, `sigma_p`.

Methods
-------
* Method of binning, `MB`.
* Machine learning, `ML`.
* Quasi static, `QS`.

A method maps a dataset to a model. A model maps the triple `(U, alpha, I)` to the pair `(P_pred, rho_pred)` consisting of the predicted mean power `P_pred` and one or more measures `rho_pred` of dispersion of the mean power, e.g. the sample standard deviation of several suggested mean powers used interally in the model.

Part I: Synthetic data
----------------------
1. Compare predicted dispersion with sample dispersion. The purpose is to give the reader some faith in the models' ability to provide a credible measure of dispersion. Divide the parameter space of `U`, `alpha`, and `I` into small regions that still contain a decent number of points. For each method, obtain a model from the entire dataset. For each point in each region, obtain a prediction of the mean power. From these predictions of mean power, obtain a sample-based measure of the dispersion of the predicted mean power. Compare this dispersion with the dispersion obtained from a single representative point in the region, e.g. the center.

2. One training dataset and one verification dataset. Make a training dataset and a verification dataset. For each method, obtain a model from the training dataset. From `U`, `alpha`, and `I` in the verification dataset, predict the mean power and form the error `epsilon = P_pred - P_true`, where `P_true` is the corresponding mean power from the verification dataset. Make various plots of `epsilon` and `rho_pred`, merging `U` and `alpha` into the rotor equivalent mean wind speed, `W`, which is the same as the mean driving wind speed in the quasi static model.

3. Bootstrap point 2 to obtain a distribution of errors. The mean of these errors is the bias and it should be small. Make plots as appropriate.

Part II: Field data
-------------------
* Obtain field data.
* Repeat part I using the field data.
