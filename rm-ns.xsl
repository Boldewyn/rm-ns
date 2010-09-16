<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- The namespace whose elements/attributes should be erased -->
  <param name="namespace" select="''" />

  <!-- whether children of a matching element should be processed further or deleted -->
  <param name="copy-children" select="true()" />

  <!-- whether attributes should be erased, too. Useful especially for the empty namespace case. -->
  <param name="remove-attributes" select="true()" />

  <!--
    ROOT

    * If the root element is of the namespace in question, replace it with an
      element <root /> in the empty namespace
    -->
  <template match="/">
    <choose>
      <when test="namespace-uri(*[1]) = $namespace">
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
    * process child nodes only, if $copy-children is true
    * otherwise do nothing (delete element)
    -->
  <template match="*">
    <choose>
      <when test="namespace-uri() != $namespace">
        <copy>
          <apply-templates select="*|@*|text()" />
        </copy>
      </when>
      <when test="$copy-children">
        <apply-templates select="*|text()" />
      </when>
      <otherwise />
    </choose>
  </template>

  <!--
    ATTRIBUTES

    * copy, if namespace doesn't match $namespace
    * copy, if $remove-attributes is false
    * otherwise do nothing (delete attribute)
    -->
  <template match="@*">
    <choose>
      <when test="$namespace != namespace-uri() or not($remove-attributes)">
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

