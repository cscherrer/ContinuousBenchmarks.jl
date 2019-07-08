using CmdStan, Turing, ContinuousBenchmarks

using Mamba: describe

const binomialstanmodel = "
// Inferring a Rate
data {
  int<lower=1> n;
  int<lower=0> k;
}
parameters {
  real<lower=0,upper=1> theta;
  real<lower=0,upper=1> thetaprior;
}
model {
  // Prior Distribution for Rate Theta
  theta ~ beta(1, 1);
  thetaprior ~ beta(1, 1);
  // Observed Counts
  k ~ binomial(n, theta);
}
generated quantities {
  int<lower=0> postpredk;
  int<lower=0> priorpredk;
  postpredk <- binomial_rng(n, theta);
  priorpredk <- binomial_rng(n, thetaprior);
}
"

#global stanmodel, rc, sim
#stanmodel = Stanmodel(Sample(algorithm=CmdStan.Hmc(CmdStan.Static(0.75 * 5), CmdStan.diag_e(), 0.75, 0.0),
#  save_warmup=true, adapt=CmdStan.Adapt(engaged=false)),
#  num_samples=2000, num_warmup=0, thin=1,
#  name="binomial", model=binomialstanmodel, nchains=1);

const binomialdata = [
  Dict("n" => 10, "k" => 5)
]

#rc, sim = stan(stanmodel, binomialdata, CmdStanDir=ContinuousBenchmarks.CMDSTAN_HOME, summary=false)

#describe(sim)

@model binomial_turing(n, k) = begin
  theta ~ Beta(1, 1)
  thetaprior ~ Beta(1, 1)
  k ~ Binomial(n, theta)
end

chn = sample(binomial_turing(binomialdata[1]["n"], binomialdata[1]["k"]), HMC(2000, 0.75, 5))

descibe(chn)
