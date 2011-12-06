library(Rffi)

        # different on different operating systems
        # and the individual elements may have a different array length!
utsStringLength = if(grepl("^darwin", R.version$os)) 256 else 65 # 65 on 64-bit Linux
cif = CIF(sint32Type, list(pointerType))
utsnameType =
         # why are these stringArrayType - when they are strings, arrays of characters.
  structType(list('sysname' = stringArrayType(utsStringLength),
                  'nodename' = stringArrayType(utsStringLength),
                  'release' = stringArrayType(utsStringLength),
                  'version' = stringArrayType(utsStringLength),
                  'machine' = stringArrayType(utsStringLength)))

p = alloc(utsnameType, "R_verbose_free")
callCIF(cif, "uname", p)
u = new("RCReference", ref = p)

print(getStructField(u, 2L, utsnameType))

print(sapply(utsnameType@fieldNames,
         function(id)
            getStructField(u, id, utsnameType)))



