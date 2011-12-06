library(Rllvm)

InitializeNativeTarget()
mod = Module("dotC")


fun = Function("callRFun", Int32Type, module = mod)

call = createLocalVariable(ir, PointerType, "call")
ans = createLocalVariable(ir, PointerType, "ans")
ptr = createLocalVariable(ir, PointerType, "ptr")

LANGSXP = 6L
langsxp = createIntegerConstant(LANGSXP)
runif = Function("allocVector", PointerType, list(Int32Type, Int32Type), module = mod)
ir$createCall(allocVector, langsxp, createIntegerConstant(2L))

# allocVector, PROTECT, SETCAR, CDR, Rf_eval, ScalarReal, asReal
runif = Function("runif", DoubleType, module = mod)
setLinkage(runif, ExternalLinkage)


b = Block(fun, "entry")

ret = Block(fun)
