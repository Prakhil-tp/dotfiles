from Xlib.display import Display
from Xlib.X import AnyPropertyType

#active_id = hex(Display().screen().root.get_full_property(Display().get_atom("_NET_ACTIVE_WINDOW"), AnyPropertyType).value[0])
#print(Display().screen().root)
id = hex(Display().screen().root.id)
print(id)
