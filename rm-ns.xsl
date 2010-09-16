<?xml version="1.0" encoding="utf-8"?>
<!--
  rm-ns
  remove namespace

  Tool to remove elements and attributes of a certain namespace
  see http://github.com/Boldewyn/rm-ns
  Copyright (c) 2010 Manuel Strehl
  Dual licensed under the MIT or GPL Version 2 licenses.
  -->
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- The namespace whose elements/attributes should be erased -->
  <param name="namespace" select="''" />

  <!-- whether children of a matching element should be processed further or deleted -->
  <param name="copy_children" select="true()" />

  <!-- whether attributes should be erased, too. Useful especially for the empty namespace case. -->
  <param name="remove_attributes" select="true()" />

  <!--
    ROOT

    * If the root element is of the namespace in question, replace it with an
      element <root /> in the empty namespace
    -->
  <template match="/">
    <choose>
      <when test="namespace-uri(*[1]) = $namespace">
        <message>
          WARNING! The root node is targeted for deletion. Wrapping the remaining document.
        </message>
        <root xmlns="">
          <apply-templates xmlns="http://www.w3.org/1999/XSL/Transform" />
        </root>
      </when>
      <otherwise>
        <apply-templates />
      </otherwise>
    </choose>
  </template>

  <!--
    ELEMENTS

    * copy, if namespace doesn't match $namespace, and process all children and attributes
    * process child nodes only, if $copy_children is true
    * otherwise do nothing (delete element)
    -->
  <template match="*">
    <choose>
      <when test="namespace-uri() != $namespace">
        <copy>
          <apply-templates select="*|@*|text()" />
        </copy>
      </when>
      <when test="$copy_children">
        <apply-templates select="*|text()" />
      </when>
      <otherwise />
    </choose>
  </template>

  <!--
    ATTRIBUTES

    * copy, if namespace doesn't match $namespace
    * copy, if $remove_attributes is false
    * otherwise do nothing (delete attribute)
    -->
  <template match="@*">
    <choose>
      <when test="$namespace != namespace-uri() or not($remove_attributes)">
        <copy />
      </when>
      <otherwise />
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

