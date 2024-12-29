# https://github.com/openhackathons-org/End-to-End-AI-for-Science/blob/688a7244b6ec0c6fa1bb939926e6a45979161248/workspace/python/source_code/projectile/projectile_eqn.py

from sympy import Symbol, Function, Number, sin, pi, exp
from modulus.sym.eq.pde import PDE

class ProjectileEquation(PDE):
    name = "ProjectileEquation"

    def __init__(self):

        #time
        t = Symbol("t")

        #make input variables
        input_variables = {"t": t}

        #make y function
        x = Function("x")(*input_variables)
        y = Function("y")(*input_variables)
        

        #set equation
        self.equations = {}
        self.equations["ode_x"] = x.diff(t,2)
        self.equations["ode_y"] = y.diff(t,2)