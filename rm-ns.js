/**
 * rm-ns
 * remove namespace
 *
 * Tool to remove elements and attributes of a certain namespace
 * @see http://github.com/Boldewyn/rm-ns
 * @copyright Copyright (c) 2010 Manuel Strehl
 * @license Dual licensed under the MIT or GPL Version 2 licenses.
 */
(function (w, d, u) {

function _rm_ns(namespace, context, copy_children, remove_attributes) {
  context = context || d;
  namespace = namespace || '';
  if (copy_children === u) { copy_children = true; }
  if (remove_attributes == u) { remove_attributes = true; }
  var i, j, f, x, nodes = context.getElementsByTagNameNS(namespace, '*');

  while (nodes.length) {
    if (! copy_children) {
      nodes[0].parentNode.removeChild(nodes[0]);
    } else {
      f = document.createDocumentFragment();
      while (nodes[0].childNodes.length) {
        f.appendChild(nodes[0].removeChild(nodes[0].childNodes[0]));
      }
      nodes[0].parentNode.replaceChild(f, nodes[0]);
    }
  }

  if (remove_attributes) {
    nodes = context.getElementsByTagName("*");
    for (i in nodes) {
      f = nodes[i].attributes, x = [];
      for (j in f) {
        if (f[j].namespaceURI == namespace) {
          x.push(f[j]);
        }
      }
      while (x.length) {
        nodes[i].removeAttribute(x[0]);
      }
    }
  }
};

var _nc = w.remove_namespace;
w.remove_namespace = _rm_ns;
w.remove_namespace.no_conflict = function () { w.remove_namespace = _nc; };
})(window, document);
