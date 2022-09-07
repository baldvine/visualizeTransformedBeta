# Visualizing the Transformed Beta Distribution and its Modifications

Simple shiny app to visualize the transformed beta distribution (TRB) and some of its
modifications. Application is hosted here: <a href="https://baldvine.shinyapps.io/visualizeTransformedBeta/" target="_blank">https://baldvine.shinyapps.io/visualizeTransformedBeta/</a>


The density function of a TRB random variable, $T$, has four parameters, $r$, $s$, $\alpha$, and $\beta$, and has the following form (see reference 1):
$$
f_{T}(x|r,s,\alpha,\beta) = \frac{\alpha/\beta}{B(r,s)} \frac{(x/\beta)^{\alpha r -1}}{(1+(x/\beta)^{\alpha})^{r+s}}, \qquad x > 0.
$$
The cdf has the following form:
$$
F_{T}(x; r, s, \alpha, \beta) = \frac{1}{B(r,s)}
\int\limits_{0}^{(x/\beta)^{\alpha}}
\frac{t^{r-1}}{(1+t)^{r+s}} dt, x > 0.
$$

The $n$-th moments of a TRB are
$$
E[T^{n}] = \beta^{n}\frac{B(r + n/\alpha, s-n/\alpha)}{B(r,s)}
$$
which exist when $\alpha s >n$.

The first modification is limiting the distribution at some value $l$, denoted as $T\wedge l$, see reference 3 for details. This places the mass above $l$, $1-F_{T}(l)$, as a discrete probability (or atom) at $l$. The moments of such a distribution can be shown to take the form
$$
E[(T\wedge l)^{n}] = E[T^{n}] F_{B}(q_{l}; r + n/\alpha, s-n/\alpha) + l^{n}(1-F_{T}(l)),
$$
where 
$$
q := \frac{(l/\beta)^{\alpha}}{1+(l/\beta)^{\alpha}},
$$ 
and $F_{B}$ is the cdf of a beta distribution.

The second modification is that of zero-inflating the distribution (see reference 4), denoted $T_{0}$. Similarly as above, this places a discrete probability $p_{0}$ at zero, and scales the remaining (possibly limited) distribution. The moments are simply scaled:
$$
E[T_{0}^{n}] = (1-p_{0})E[T^{n}].
$$

Density obtained from made with the `dtrbeta()` function from the package <a href="https://cran.r-project.org/web/packages/actuar/index.html" target="_blank">actuar package</a>.


**Note**: Math is not easily rendered in markdown files. However, the html file looks good. To quickly view without having to download, do the following dance steps:

i) Click on html file in github repository and copy the url

ii) Go to <a href="http://htmlpreview.github.io/" target="_blank">http://htmlpreview.github.io/</a> and paste


**Further note**
Another reparameterization (see reference 2) is the following:
$$
f_{T}(x|a,b,c,d) = \frac{c/d}{B(b/c, a/c)} \left(x/d\right)^{b-1} \left(1 + \left(x/d\right)^{c}\right) ^{-\frac{a+b}{c}}
$$
which is easily obtained from the standard parameters by comparing the two density functions
$$
a = \alpha s, \qquad b = \alpha r  \qquad c = \alpha, \qquad d = \beta.
$$


## References

1. Venter, Gary G. 1983. Transformed beta and gamma distributions and aggregate losses. *Proceedings of the Casualty Actuarial Society LXX*, 289-308.

2. Venter, Gary G. 2003. Effects of parameters of transformed beta distributions. *Winter Forums of the Casualty Actuarial Society*.

3. Ospina, Raydonal and Silvia L. P. Ferrari. 2010. Inflated beta distributions. *Statistical Papers* 51(1), 111-126.

4. Klugman, Stuart A., Harry H. Panjer, and Gordon E. Willmot. 2012. *Loss Models: From Data to Decisions (4 th. ed.).* John Wiley & Sons.
