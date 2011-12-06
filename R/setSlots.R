
setSlots =
function(els, obj)
{
  for(i in names(els))
     slot(obj, i) = els[[i]]
  obj
}

