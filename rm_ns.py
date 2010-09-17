"""rm-ns: remove namespace

Tool to remove elements and attributes of a certain namespace
@see http://github.com/Boldewyn/rm-ns
@copyright Copyright (c) 2010 Manuel Strehl
@license Dual licensed under the MIT or GPL Version 2 licenses.
"""


import xml.dom
import xml.dom.minidom


def remove_namespace(namespace, context, copy_children=None,
                     remove_attributes=None):
    """Remove all elements and attributes in a certain namespace

    Parameters:
    namespace          The namespace in question
    context            An instance of xml.dom.Node, from that the removal
                       should start
    copy_children      Whether children of a matching element should be copied
    remove_attributes  Whether matching attributes should be removed, too.
                       This is useful, when namespace is the empty namespace
    """
    if copy_children is None:
        copy_children = True
    if remove_attributes is None:
        remove_attributes = True
    if namespace is None:
        namespace = xml.dom.EMPTY_NAMESPACE
    document = context
    while not isinstance(document, xml.dom.minidom.Document):
        document = document.parentNode
    nodes = context.getElementsByTagNameNS(namespace, '*')

    for node in nodes:
        if node.parentNode is None:
            continue
        if not copy_children:
            node.parentNode.removeChild(node)
        else:
            frag = document.createDocumentFragment()
            while len(node.childNodes):
                frag.appendChild(node.removeChild(
                    node.childNodes.item(0)))
            node.parentNode.replaceChild(frag, node)

    if remove_attributes:
        nodes = context.getElementsByTagName("*")
        for node in nodes:
            attributes = node.attributes
            i = 0
            while i < attributes.length:
                if attributes.item(i).namespaceURI == namespace:
                    node.removeAttributeNode(attributes.item(i))
                else:
                    i += 1

