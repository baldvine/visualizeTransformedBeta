# Visualizing the Transformed Beta Distribution

Simple shiny app to visualize the transformed beta distribution. Application is hosted here: <a href="https://baldvine.shinyapps.io/visualizeTransformedBeta/" target="_blank">https://baldvine.shinyapps.io/visualizeTransformedBeta/</a>


The density function has four parameters, $r$, $s$, $\alpha$, and $\beta$, and has the following form:
$$
f(x|r,s,\alpha,\beta) = \frac{\alpha/\beta}{B(r,s)} \frac{(x/\beta)^{\alpha r -1}}{(1+(x/\beta)^{\alpha})^{r+s}}, \qquad x > 0
$$

However, a common reparameterization is the following:
$$
f(x|r,s,\alpha,\beta) \propto \left(x/d\right)^{b-1} \left(1 + \left(x/d\right)^{c}\right) ^{-\frac{a+b}{c}}
$$
which is easily obtained from the standard parameters by comparing the two density functions
$$
a = \alpha s, \qquad b = \alpha r  \qquad c = \alpha, \qquad d = \beta.
$$

All plots made with the `dtrbeta()` function from the package <a href="https://cran.r-project.org/web/packages/actuar/index.html" target="_blank">actuar package</a>.


**Note**: Math is not easily rendered in markdown files. However, the html file looks good. To quickly view without having to download, do the following dance steps:

i) Click on html file in github repository and copy the url

ii) Go to <a href="http://htmlpreview.github.io/" target="_blank">http://htmlpreview.github.io/</a> and paste



## References

1. Gary G. Venter. Transformed beta and gamma distributions and aggregate
losses. *Proceedings of the Casualty Actuarial Society*, LXX, 1983.

2. Gary G. Venter. Effects of parameters of transformed beta distributions.
*Winter Forums of the Casualty Actuarial Society*, 2003.

