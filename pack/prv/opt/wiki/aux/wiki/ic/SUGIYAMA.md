Dom Jan 14 06:18:24 -02 2018

Sugiyama, Intro to Stat ML, 2016

===========
### Preface
"Machine learning is a subject in computer science, aimed at studying
theories,
algorithms, and applications of systems that learn like humans."
(first words)

Other books of the author about the subjects in this book.

### Cap 1:
Divides ML in sup, unsup and reinforcement learning!!!

Divides sup in class, reg and ranking!!

Unsup as preproc for sup.

Reinforcement based in sup and unsup.
For reinf there is another book.

. | Todo make chat bot with reinf.

1.2.1.
closeness = (f - f')
ranking alias ordinal regression

1.2.2
clustering is unsup classification!
similarity in clustering

outlier detection as unsup
and uses similarity

outlier detection alias change detection

change detection with outlier detection
change detection alias novelty detection

1.2.3.
Semi-supervised learning.
" :Todo Make a point anbout semi-supervised learning:
it helps not only when output samples are costly!
TTM

ensemble learning

matrix learning, tensor learning

online learning.
" :Question diff of online and reinforcement learning

transfer learning (or domain adaptation)
and multitask learning

" :Question what is the diff between computational intelligence and artificial intelligence.

Metric learning, dimensionality reduction,
linear, supervised and unsupervised dimensionality reduction.
" :Question add a semi-supervised dimensionality reduction?
Curse of dimensionality.
High-dimensional data VS low-dimensional expression.

1.3.
fundamental concepts of statistics and probability

machine learning techniques

generative approach
statistical pattern recognition
probability distribution of data
perform pattern recognition
data generation mechanisms
classification and clustering, frequentist and Bayesian

discriminative approach
statistical machine learning
solve task
without data-generating prob distributions
no data on generation mechanisms => more promising then generative
optimization theory

" :Idea to make a data mining bot: find data cubes in linked data and
make some sort of summarization. Try to collapse in a
lower-dimensional cube. Relate the dimensional URIs through
the Pearson and Spearman coefficients and collectively through the
most or least prominent in the PCA.

" :Question things concentrate! Few greater PCA components hold almost all
the variance. Few hubs.... See in which conditions a PCA result
exhibits a power-law distribution of (abs) eigenvalues.


### Chap 2
rand var & prob dist (are base to) prob & stat
simple stat summarize prob dist
" :Todo use the sentence above to talk about
statistics in machine learning:
prob has two meanings, stat has two meanings.
2.2-3 bellow has the definition og prob, random variable, etc...

#### 2.1
Sample points, sample space, event

empty, elementary, composite, whole event.
" :Question is the whole event the sample space?

Complementary event, disjoint events.
Union and intersection of events,
Distributive laws 1 and 2.
Morgan's laws 1 and 2.

### 2.2
" :Definition probability: a measure of the likeliness
that an event will occur.

kolmogorov: non-negativity, unitarity, additivity.
additive law of disjoint and overlapping events.

### 2.3
" Definition random variable: each realization has a probability
assigned.

(1) probability distribution: describes the mapping from any realized
value to probability.

countable set, discrete random variable, probability mass function (2) 

continuous random variable, probability density function (3)

(2) and (3) are types of (1).
" :Question are there other types of (1)? In a fractal random
variable? Any other?

cumulative distribution function
monotone nondecreasing, left and right limits

upper-tail or right-tail probability
lower-tail or left-tail probability
two-sided and one-sided probability

### 2.4
#### 2.4.1
expectation, median, alpha-quantile

expectation minimizes square and absolute error.
quantiles minimize weighted versions

#### 2.4.2
variance and std

#### 2.4.3
skewness é obliquidade ou assimetria (wikipedia)
kurtosis é curtose.

momentos sobre a esperança e sobre a origem.

funcao geradora de momentos,
função característica que é a transf de fourier de funcoes densidade
de prob.

" :Todo entender a funcao caracteristica e sua relacao com Fourier.

### 2.5 
standardization

normalization with the jacobian.
---> esta parte ficou no ar totalmente...
Pq chama dx/dr d jacobiana? g(r) é um só
ou confunde com Fig 2.9?
Qual a validade da exposição sobre transf de var?

### Chap 3 

### 3.1
uniforme: desvio e media.

### 3.2
" :Todo derive the binomial coefficient.

" :Todo derive the binomial theorem by heart

### 3.3
amostragem com e sem reposicao.
dist e serie hipergeometrica


### 3.4
poisson dist and bernoulli trials and binomial dists

Poisson's low of small numbers
euler definition

### 3.5
Negative binomial dist alias Pascal dist

negative binomial coefficient in the binomial meaning and theorem.

### 3.6 
geometric is negative binomial with k=1

================
### Chap 4

### 4.2
Gaussian integral

Standard normal distribution

### 4.3
gamma, exponential, chi-squared dists

### 4.4
beta distribution and function
beta in terms of gamma dists

### 4.5
Cauchy and Laplace distributions (heavy tailed)
Laplace dist alias double exponential dist

a location (principal value) b scale of the cauchy

### 4.6
Student's t-distribution
Snedecor's F-distribution

" Question: no power-law distribution???

============
### Chap 5

### 5.1
joint probability distribution
joint probability mass function

marginal probability mass function
marginal probability distribution
marginalization

joint probability density function
marginal probability density functions

### 5.2
conditional probability distribution
conditional probability mass function
conditional expectation
conditional variance
conditional probability density function

### 5.3
contingency table (of discrete random variables)
row marginal total
column marginal total
grand total

### 5.4
Bayes' theorem
cause and effect
prior and posterior probabilities
poligraph example

### 5.5
covariance
variance-covariance matrix
correlation coefficient
positively and negatively correlated
uncorrelated

### 5.6
independence
dependent
properties of independent rand vars
correlation vs dependence

=======
### Chap 6

### 6.1
multinomial dist
multinomial theorem

### 6.2
multivariate normal dist
elliptic, circle contour lines and the eigendecomposition

### 6.3
Dirichlet dist
from gamma distributions
d-dimensional beta function
" :Todo visitar outro material sobre esta dist para me convencer a
absorver sobre ela
multidimensional extension of the beta dist
symmetric Dirichlet dist
concentration parameter

### 6.4
Whishart dist
d-dimensional gamma function
Wishart dist as a multidim ext of the gamma dist
chi-squared dist
vectorization operator
Kronecker product

=========
### Chap 7

### 7.1
conv eh soma de vars rand

### 7.2
reproductive prob dist
x, y ind => M_x,y(t) = M_x(t) . M_y(t)
" :Question Why is the moment-generating function as is?
Why E[exp(t)]?

se soma de 2 dist eh da mesma familia, como que o teorema
do limite central se sustenta?
Ou seja, se somar varias Gamma, por ser uma dist reprodutiva,
dah uma Gama.
Pelo teo do limite central (TLC) daria normal
somente se as dist tivessem mesma media e variancia,
e no caso a soma d 2 eh ainda gamma, mas a terceira haj eh soma
de gammas diferentes.

Geometric and exponential distributions do not have the
reproductive property.

### 7.3
mean and variance of the sample mean.
weak law of large numbers (converge in probability to mean)
if the original dist has variance use Chebyshev's inequality??

strong law of large numbers (almost surely converges to the mean)

i.i.d. vars (independent and identical variables?)

### 7.4
central limit theory (sum converges in law or in distribution to the
normal distribution)
Or sum asymptotically follows te normal distribution Or
has asymptotic normality.

============
### Chap 8
úteis quando somente a media ou variancia sao dadas, por exemplo.

### 8.1
union bound

### 8.2
Markov's inequality
Chernoff's inequality

### 8.2.2
Cantelli's inequality
one-sided Chebyshev's inequality

Chebyshev's inequality

### 8.3
### 8.3.1
convex function
Jensen's inequality

### 8.3.2
Hölder's inequality
Schwarz's inequality

### 8.3.3
Minkowsky's inequality

### 8.3.4
Kantorovich's inequality

### 8.4

### 8.4.1
Chebyshev's inequality and Chernoff's inequality for sum and average
of random variables

### 8.4.2
Hoeffding's inequality
Bernstein's inequality (gives a tighter bound the Hoeffding's

### 8.4.3
Bennet's inequality (giver a tighter bound then Bernstein's
inequality)

TTM: rever este capítulo, estudar as desigualdades e entender quais
variáveis estão sendo relacionadas.

" :Todo implement the concepts of all the chapters as python scripts

============
### Chap 9
statistical estimation

### 9.1
estimator
estimate
parametric models and methods
nonparametric methods

### 9.2
point estimation

### 9.2.1
Maximum likelihood estimation
likelihood
parameter as a deterministic var (in max lik est)
and as a random var (in Bayesian inf)

Prior prob (problematic)
Likelihood
Posterior prob

posterior expectation
posterior mode (maximum a posteriori probability estimation)

frequentist inference (MLE) vs Bayesian inference

### 9.2.2
Kernel density estimation (KDE)
kernel function
Gaussian kernel function and its bandwidth

Nearest neighbor density estimation (NNDE)

### 9.2.3
regression classification
least squares
regularization
LS equivalent to MLE if y considered normal
equivalent to Bayesian max a post prob est if
the prior prob follows normal

### 9.2.4
Model selection

cross validation for frequentist
marginal likelihood for Baysesian (type-II maximum likelihood
estimation or empirical Bayes method)

### 9.3
confidence interval
confidence level

### 9.3.1
interval estimation of expectation for normal samples
with and without std given.

Studentization

### 9.3.2
boostrap to estimate the confidence interval

### 9.3.3
Bayesian credible interval is the confidence interval
for Bayesian inference.

============
### Chap 10
framework of hypothesis testing

### 10.1
null hypothesis H\_0
alternative hypothesis H\_1
p-value (probability that the sample occured under the null hypothesis)
significance level (alpha)
accept null hypothesis: proof by contradiction

" :Question probability vs chance

two-sided test: test equality of observed and target.
one-sided test: test if observed is larger or smaller than target
value.

test statistic 
critical values
critical region

### 10.2
z-test
t-test

### 10.3
type-I error: false positive
type-II error: false negative = beta
1-beta = power of the test

in framework of hypothesis testing:
type-I error is alpha
type-II error is minimized (as possible)

Neyman-Perason lemma
likelihood-ratio test

" :Todo rever likelihood p absorver o lema de Neyman-Pearson

### 10.4
goodness-of fit test:
Pearson divergence follows chi-squared dist with lm -1 degrees of
freedom

independence test:
Pearson divergence follows the chi-squared dist with (l-1)(m-1)
deegres of freedom
when x and y follow multinomial dists

Kullback-Leibler divergence for the G-test
approx. follows chi-squared with (l-1)(m-1) deeg of freed

chi-square test

### 10.5
### 10.5.1
unpaired z-test
unpaired t-test
Welch's t-test
F-test
### 10.5.2
paired z-test
paired t-test
### 10.6
nonparametric tests
### 10.6.1
Wilcoxon rank-sum test
Mann-Whitney U-test
### 10.6.2
Wilcoxon signed-rank test
### 10.7
Monte Carlo method.
Monte Carlo test
Fisher's exact test
MC test as a generalization of Fisher's

" :Todo understand Fisher's exact test and this end of section.

" :Todo understand what means enumeration of all possible
(combinations, partitions) and why it yields relations
from these tests to the MC test.

permutation test (and its approximation by MC test)

========================
Parte 2 - generative approach to statistical pattern recognition

### 11
generative model estimation

# 11.1
pattern, feたture vector, input variable, independent variable,
explanatory variable, exogenous variable, predictor variable,
regressor, covariate

pattern space

class, category, output variable, target variable, dependent variable

classifier, discrimination function

decision region, decision boundary

statistical pattern recognition

generalization ability

# 11.2
training samples

class-prior prёbability
class-conditional probability density

# 11.3
# 11.3.1
class-posterior probability

MAP rule

# 11.3.2
minimum misclassification rate rule

minizing the misclassification rate rule is equivalent to maximizing
the class-posterior probability

# 11.3.3
Bayes decision rule

loss

conditional risk of pattern x

total risk
Bayes risk

# 1⒈.4
discriminative approach (uses class-posterior prob)
generative approach (uses class-prior and class-conditional probs)

parametric and non-parametric

### 12
maximum likelihood estimation (MLE)
generic method for parameter estimation
one of the most used techniques
proposed in the beggining of the XX century

# 12.1
parametric model
likelihood equation
log-likelihood

# 12.2
Gaussian model
vector and matrix derivatives (fig 12.3)

# 12.3
Mahalanobis distance between x and \mu

# 12.4
Fisher's linear discriminant analysis (FDA)

# 12.5
# 12.5.1
tensors

# 12.5.2
# 12.5.3
TODO: implement MLE in python as in the this and the last chapter.
Translate the matlab code and check to see if the results match.


### 13

