<?xml version="1.0" ?>
<!--
  mv-ns
  move namespaces

  Tool to move nodes from one namespace to another
  see http://github.com/Boldewyn/rm-ns
  Copyright (c) 2010 Manuel Strehl
  Dual licensed under the MIT or GPL Version 2 licenses.
  -->
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- The namespace whose nodes should be moved -->
  <param name="namespace" select="''" />

  <!-- The namespace the nodes should be moved to -->
  <param name="target_namespace" select="''" />

  <!-- whether attributes should be moved, too. -->
  <param name="move_attributes" select="true()" />

  <!--
    ELEMENTS

    * copy, if namespace doesn't match $namespace
    * otherwise insert a new element in the target namespace with the same local name
    -->
  <template match="*">
    <choose>
      <when test="namespace-uri() != $namespace">
        <copy>
          <apply-templates select="*|@*|text()" />
        </copy>
      </when>
      <otherwise>
        <element name="local-name(.)" namespace="$target_namespace">
          <apply-templates select="*|@*|text()" />
        </element>
      </otherwise>
    </choose>
  </template>

  <!--
    ATTRIBUTES

    * copy, if namespace doesn't match $namespace or attributes should be ignored
    * otherwise insert a new attribute in the target namespace
    -->
  <template match="@*">
    <choose>
      <when test="$namespace != namespace-uri() or not($move_attributes)">
        <copy />
      </when>
      <otherwise>
        <attribute name="local-name(.)" namespace="$target_namespace">
          <value-of select="." />
        </attribute>
      </otherwise>
    </choose>
  </template>

  <!--
    EVERYTHING ELSE

    * copy regardless
    -->
  <template match="processing-instruction()|comment()|text()">
    <copy />
  </template>

</stylesheet>

