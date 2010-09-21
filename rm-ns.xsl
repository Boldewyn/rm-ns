<?xml version="1.0" ?>
<!--
  rm-ns
  remove namespace

  Tool to remove all nodes of a certain namespace
  see http://github.com/Boldewyn/rm-ns
  Copyright (c) 2010 Manuel Strehl
  Dual licensed under the MIT or GPL Version 2 licenses.
  -->
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- The namespace whose nodes should be erased -->
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
    <apply-templates mode="findroot" />
  </template>

  <!--
    Search the first element, that should not be stripped
  -->
  <template match="*" mode="findroot">
    <choose>
      <when test="namespace-uri(.) != $namespace">
        <apply-templates select="." />
      </when>
      <when test="not(normalize-space(child::text())) and count(./*) = 1">
        <apply-templates select="*" mode="findroot" />
      </when>
      <otherwise>
        <message>
          WARNING! The root node is targeted for deletion. Wrapping the remaining document.
        </message>
        <root xmlns="">
          <apply-templates xmlns="http://www.w3.org/1999/XSL/Transform" />
        </root>
      </otherwise>
    </choose>
  </template>

  <template match="text()|comment()|processing-instruction()" mode="findroot">
    <copy />
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
          <apply-templates select="*|@*|text()|processing-instruction()|comment()" />
        </copy>
      </when>
      <when test="$copy_children">
        <apply-templates select="*|text()|processing-instruction()|comment()" />
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

