import numpy as np

def logit_py(x):
  return np.exp(x)/(1+np.exp(x))
