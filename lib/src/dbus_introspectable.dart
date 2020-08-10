import 'dbus_introspect.dart';
import 'dbus_method_response.dart';
import 'dbus_object_tree.dart';
import 'dbus_peer.dart';
import 'dbus_value.dart';

/// Returns introspection data for the org.freedesktop.DBus.Introspectable interface.
DBusIntrospectInterface introspectIntrospectable() {
  final introspectMethod = DBusIntrospectMethod('Introspect', args: [
    DBusIntrospectArgument(
        'xml_data', DBusSignature('s'), DBusArgumentDirection.out)
  ]);
  final introspectable = DBusIntrospectInterface(
      'org.freedesktop.DBus.Introspectable',
      methods: [introspectMethod]);
  return introspectable;
}

/// Handles method calls on the org.freedesktop.DBus.Introspectable interface.
DBusMethodResponse handleIntrospectableMethodCall(DBusObjectTree objectTree,
    DBusObjectPath path, String member, List<DBusValue> values) {
  if (member == 'Introspect') {
    var node = objectTree.lookup(path);
    var interfaces = <DBusIntrospectInterface>[];
    if (node != null && node.object != null) {
      interfaces.add(introspectIntrospectable());
      interfaces.add(introspectPeer());
      interfaces.addAll(node.object.introspect());
    }
    var children =
        node.children.keys.map((name) => DBusIntrospectNode(name)).toList();
    var xml =
        DBusIntrospectNode(null, interfaces, children).toXml().toXmlString();
    return DBusMethodSuccessResponse([DBusString(xml)]);
  } else {
    return DBusMethodErrorResponse.unknownMethod();
  }
}
