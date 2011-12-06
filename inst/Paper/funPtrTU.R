# This is for runFunPtr in ../../src/test.c - not the optimize() in the paper.

createCallRFunctionWrapper =
function(funPtr,    # the description of the function pointer - class FunctionPointer
         funcName,  # name of the routine we create
                    # index of parameter that is the user data containing the R function SEXP
         userDataParam = findUserDataParam(funPtr),
                    # names to use for the parameters of the routine
         paramNames = names(funPtr@parmeters))
{
        # So we have an explicit representation for a FunctionPointer
        # We have the return type and the parameters. From these we can
        # define our wrapper routine
  if(length(names(funPtr@parameters)) == 0)  #?  NULL since the TU loses them - yes!
      names(funPtr@parameters) = paste("x", seq(along = funPtr@parameters), sep = "")


     # Now create the body of the routine first.
   params = funPtr@parameters
   body = c(
                  # local variables
             "SEXP call, ans, ptr;", 

                  # create the call
             sprintf("PROTECT(ptr = call = allocVector(LANGSXP, %d));", length(params)),

                  # put the function into the first element of the call
             sprintf("SETCAR(ptr, (SEXP) %s); ptr = CDR(ptr);", names(params)[ userDataParam ]),
                  # add each of the parameters, except the userDataParam
             mapply(function(id, parm)
                       sprintf("SETCAR(ptr, %s); ptr = CDR(ptr);", convertValueToR(id, parm@type)),
                    names(params)[ - userDataParam], params[ - userDataParam]),

                  # invoke the call
             "ans = Rf_eval(call, R_GlobalEnv);",
  
             "UNPROTECT(1);",
                  # conver the result back to a C value
             sprintf("return(%s);", gsub(";$", "", convertRValue("",  "ans", funPtr@returnType)))
            )

       # Now we have to get its declaration or signature to add to the top of the body
   ret = getNativeDeclaration("", funPtr@returnType, addSemiColon = FALSE)
   decl = mapply(getNativeDeclaration, names(params),
                                       lapply(params, function(x) x@type),
                  MoreArgs = list(addSemiColon = FALSE))


       # put the pieces of the code together into a character vector
  c(ret,
      sprintf("%s(%s)", funcName, paste(decl, collapse = ", ")),
      "{",
      paste("    ", body),
      "}")

}



