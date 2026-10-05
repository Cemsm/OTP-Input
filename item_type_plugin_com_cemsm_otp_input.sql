prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.0'
,p_default_workspace_id=>8747817710043504
,p_default_application_id=>132
,p_default_id_offset=>0
,p_default_owner=>'TEST'
);
end;
/
 
prompt APPLICATION 132 - watchtower
--
-- Application Export:
--   Application:     132
--   Name:            watchtower
--   Date and Time:   14:37 Monday October 5, 2026
--   Exported By:     TEST
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 15967538395161608
--   Manifest End
--   Version:         26.1.0
--   Instance ID:     939566546695539
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_cemsm_otp_input
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(15967538395161608)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM_CEMSM_OTP_INPUT'
,p_display_name=>'OTP Input'
,p_apexlang_name=>'otpInput'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_javascript_file_urls=>'#PLUGIN_FILES#otp-input#MIN#.js'
,p_css_file_urls=>'#PLUGIN_FILES#otp-input#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- COM_CEMSM_OTP_INPUT 0.1.0',
'-- Render Procedure: otp_render | Validation Procedure: otp_validate',
'',
'function otp_length(p_item in apex_plugin.t_item) return pls_integer is',
'    l_length pls_integer;',
'begin',
'    l_length := to_number(nvl(p_item.attributes.get_varchar2(''length''), ''6''));',
'    return greatest(4, least(8, l_length));',
'exception',
'    when others then',
'        return 6;',
'end;',
'',
'-- Shared check: returns an error message, or null if the value is fine.',
'function otp_check(p_item in apex_plugin.t_item, p_value in varchar2) return varchar2 is',
'    l_length pls_integer  := otp_length(p_item);',
'    l_type   varchar2(20) := nvl(p_item.attributes.get_varchar2(''input_type''), ''NUMERIC'');',
'begin',
'    if p_value is null then',
'        if p_item.is_required then',
'            return ''Enter the full code.'';',
'        end if;',
'        return null;',
'    end if;',
'    if length(p_value) <> l_length then',
'        return ''The code must be exactly ''||l_length||'' characters.'';',
'    end if;',
'    if l_type = ''NUMERIC'' and not regexp_like(p_value, ''^[0-9]+$'') then',
'        return ''The code must contain digits only.'';',
'    end if;',
'    if l_type = ''ALPHANUMERIC'' and not regexp_like(p_value, ''^[A-Za-z0-9]+$'') then',
'        return ''The code must contain letters and digits only.'';',
'    end if;',
'    return null;',
'end;',
'',
'procedure otp_validate(',
'    p_item   in apex_plugin.t_item,',
'    p_plugin in apex_plugin.t_plugin,',
'    p_param  in apex_plugin.t_item_validation_param,',
'    p_result in out nocopy apex_plugin.t_item_validation_result',
') is',
'    l_msg varchar2(4000) := otp_check(p_item, p_param.value);',
'begin',
'    if l_msg is not null then',
'        p_result.message          := l_msg;',
'        p_result.display_location := apex_plugin.c_inline_with_field_and_notif;',
'    end if;',
'end;',
'',
'procedure otp_render(',
'    p_item   in apex_plugin.t_item,',
'    p_plugin in apex_plugin.t_plugin,',
'    p_param  in apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result',
') is',
'    l_json      varchar2(32767);',
'    l_name      varchar2(255);',
'    l_value     varchar2(4000) := p_param.value;',
'    l_mask      varchar2(1)    := nvl(p_item.attributes.get_varchar2(''mask''), ''N'');',
'    l_separator pls_integer;',
'begin',
'    if p_param.is_readonly or p_param.is_printer_friendly then',
'        apex_plugin_util.print_hidden_if_readonly(',
'            p_item_name           => p_item.name,',
'            p_value               => p_param.value,',
'            p_is_readonly         => p_param.is_readonly,',
'            p_is_printer_friendly => p_param.is_printer_friendly);',
'        sys.htp.p(''<span class="display_only">''||apex_escape.html(',
'            case when l_mask = ''Y''',
'                 then rpad(''*'', nvl(length(p_param.value), 0), ''*'')',
'                 else p_param.value end)||''</span>'');',
'        return;',
'    end if;',
'',
'    -- Drop an invalid stored/submitted value so the user can type the code again.',
'    if p_param.value is not null and otp_check(p_item, p_param.value) is not null then',
'        l_value := null;',
'    end if;',
'',
'    begin',
'        l_separator := to_number(nvl(p_item.attributes.get_varchar2(''separator_after''), ''0''));',
'    exception when others then',
'        l_separator := 0;',
'    end;',
'',
'    -- The hidden input is the real page item and holds the full code.',
'    l_name := apex_plugin.get_input_name_for_page_item(p_is_multi_value => false);',
'    sys.htp.p(''<input type="hidden" id="''||apex_escape.html_attribute(p_item.name)||',
'        ''" name="''||apex_escape.html_attribute(l_name)||''" value="''||',
'        apex_escape.html_attribute(l_value)||''">'');',
'',
'    -- The JavaScript builds the boxes inside this container.',
'    sys.htp.p(',
'        ''<div class="com-cemsm-otp-wrapper">''||',
'',
'            ''<div class="com-cemsm-otp-header">''||',
'                ''<span class="fa ''||',
'                apex_escape.html_attribute(',
'                    nvl(',
'                        p_item.attributes.get_varchar2(''icon''),',
'                        ''fa-lg fa-lock-password''',
'                    )',
'                )||',
'                '' com-cemsm-otp-header__icon" aria-hidden="true"></span>''||',
'            ''</div>''||',
'',
'            ''<div class="com-cemsm-otp-body">''||',
'',
'                ''<div class="com-cemsm-otp-title">''||',
'                    apex_escape.html(',
'                        nvl(',
'                            p_item.attributes.get_varchar2(''placeholder''),',
'                            ''Enter The Code''',
'                        )',
'                    )||',
'                ''</div>''||',
'',
'                ''<div id="''||',
'                    apex_escape.html_attribute(p_item.name||''_OTP'')||',
'                ''" class="com-cemsm-otp" role="group" aria-labelledby="''||',
'                    apex_escape.html_attribute(p_item.name||''_LABEL'')||',
'                ''"></div>''||',
'',
'            ''</div>''||',
'',
'        ''</div>''',
'    );',
'',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    apex_json.write(''length'',         otp_length(p_item));',
'    apex_json.write(''inputType'',      lower(nvl(p_item.attributes.get_varchar2(''input_type''), ''NUMERIC'')));',
'    apex_json.write(''mask'',           l_mask = ''Y'');',
'    apex_json.write(''separatorAfter'', l_separator);',
'    apex_json.write(''autoSubmit'',     lower(nvl(p_item.attributes.get_varchar2(''auto_submit''), ''NONE'')));',
'    apex_json.write(''autoFocus'',      nvl(p_item.attributes.get_varchar2(''auto_focus''), ''N'') = ''Y'');',
'    apex_json.write(''allowPaste'',     nvl(p_item.attributes.get_varchar2(''allow_paste''), ''Y'') = ''Y'');',
'    apex_json.write(''size'',           lower(nvl(p_item.attributes.get_varchar2(''size''), ''MEDIUM'')));',
'    apex_json.write(''style'',          lower(nvl(p_item.attributes.get_varchar2(''style''), ''BOXED'')));',
'    apex_json.write(''label'',          nvl(p_item.plain_label, p_item.name));',
'    apex_json.close_object;',
'    l_json := dbms_lob.substr(apex_json.get_clob_output, 32767, 1);',
'    apex_json.free_output;',
'',
'    apex_javascript.add_onload_code(',
'        p_code => ''OtpInput.mount(''||apex_javascript.add_value(p_item.name, false)||',
'                  '',JSON.parse(''||apex_javascript.add_value(l_json, false)||''));'',',
'        p_key  => ''otp_''||p_item.name);',
'',
'    p_result.is_navigable     := true;',
'    p_result.navigable_dom_id := p_item.name||''_0'';',
'end;'))
,p_api_version=>3
,p_render_function=>'otp_render'
,p_validation_function=>'otp_validate'
,p_item_session_state_data_type=>'VARCHAR2'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE'
,p_version_scn=>'SH256:SCeDJ3j98nwBM6U4ASSPk_aLY24Vb1SbhY_xt0GWvFE'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Displays a one-time code or PIN as a row of single-character boxes. The full code is stored in one page item, so it works with normal submit, session state and validations.</p>',
'<ul>',
'  <li>Typing moves to the next box. Backspace moves back. Arrow keys, Home and End navigate.</li>',
'  <li>Pasting a full code fills all boxes, and mobile SMS code suggestions are supported.</li>',
'  <li>The server checks the length and the allowed characters on submit.</li>',
'</ul>',
'<p><strong>Events:</strong> <code>otp-change</code> fires on every change and <code>otp-complete</code> fires when all boxes are filled. Use them in a Dynamic Action with the item as the affected element.</p>',
'<p><strong>Tip:</strong> to require a code, use the item''s "Value Required" setting.</p>'))
,p_version_identifier=>'0.1.0'
,p_files_version=>2461319143313
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15981062954233549)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_static_id=>'allow_paste'
,p_prompt=>'Allow Paste'
,p_apexlang_name=>'allowPaste'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'Lets users paste a full code and spreads it across the boxes. Characters not allowed by Input Type are removed.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15980562029231058)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_static_id=>'auto_focus'
,p_prompt=>'Auto Focus'
,p_apexlang_name=>'autoFocus'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Puts the cursor in the first box when the page loads.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15978173731218532)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'auto_submit'
,p_prompt=>'On Complete'
,p_apexlang_name=>'onComplete'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'NONE'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'What happens when the last box is filled. Do Nothing only fires the otp-complete event, and Submit Page also submits the page automatically.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15978646285219664)
,p_plugin_attribute_id=>wwv_flow_imp.id(15978173731218532)
,p_display_sequence=>10
,p_display_value=>'Do Nothing'
,p_return_value=>'NONE'
,p_apexlang_name=>'doNothing'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15979088319220402)
,p_plugin_attribute_id=>wwv_flow_imp.id(15978173731218532)
,p_display_sequence=>20
,p_display_value=>'Submit Page'
,p_return_value=>'SUBMIT'
,p_apexlang_name=>'submitPage'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(16005019269535343)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_static_id=>'icon'
,p_prompt=>'Icon'
,p_apexlang_name=>'icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_default_value=>'fa-lock'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15971611464180112)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'input_type'
,p_prompt=>'Input Type'
,p_apexlang_name=>'inputType'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'NUMERIC'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Which characters are accepted. Numeric allows 0-9 and shows the numeric keyboard on phones, Alphanumeric allows letters and digits, and Any allows every character.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15972596370183547)
,p_plugin_attribute_id=>wwv_flow_imp.id(15971611464180112)
,p_display_sequence=>20
,p_display_value=>'Alphanumeric'
,p_return_value=>'ALPHANUMERIC'
,p_apexlang_name=>'alphanumeric'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15972915722184445)
,p_plugin_attribute_id=>wwv_flow_imp.id(15971611464180112)
,p_display_sequence=>30
,p_display_value=>'Any'
,p_return_value=>'ANY'
,p_apexlang_name=>'any'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15972139522182119)
,p_plugin_attribute_id=>wwv_flow_imp.id(15971611464180112)
,p_display_sequence=>10
,p_display_value=>'Numeric'
,p_return_value=>'NUMERIC'
,p_apexlang_name=>'numeric'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15968052459169368)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'length'
,p_prompt=>'Length'
,p_apexlang_name=>'length'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'6'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Number of boxes to show, from 4 to 8. The code the user enters must have exactly this many characters.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15968805954170747)
,p_plugin_attribute_id=>wwv_flow_imp.id(15968052459169368)
,p_display_sequence=>10
,p_display_value=>'4'
,p_return_value=>'4'
,p_apexlang_name=>'4'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15969284788171293)
,p_plugin_attribute_id=>wwv_flow_imp.id(15968052459169368)
,p_display_sequence=>20
,p_display_value=>'5'
,p_return_value=>'5'
,p_apexlang_name=>'5'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15970211270174433)
,p_plugin_attribute_id=>wwv_flow_imp.id(15968052459169368)
,p_display_sequence=>30
,p_display_value=>'6'
,p_return_value=>'6'
,p_apexlang_name=>'6'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15970683047174898)
,p_plugin_attribute_id=>wwv_flow_imp.id(15968052459169368)
,p_display_sequence=>40
,p_display_value=>'7'
,p_return_value=>'7'
,p_apexlang_name=>'7'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15971038596175320)
,p_plugin_attribute_id=>wwv_flow_imp.id(15968052459169368)
,p_display_sequence=>50
,p_display_value=>'8'
,p_return_value=>'8'
,p_apexlang_name=>'8'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15973815844193114)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'mask'
,p_prompt=>'Mask Characters'
,p_apexlang_name=>'mask'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Show dots instead of the typed characters, like a PIN field. Turn it off for one-time codes the user needs to read back.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15991513083352280)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_static_id=>'placeholder'
,p_prompt=>'Placeholder'
,p_apexlang_name=>'placeholder'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Enter The Code'
,p_is_translatable=>false
,p_help_text=>'Provides the placeholder for the item.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15974301779195265)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'separator_after'
,p_prompt=>'Separator After'
,p_apexlang_name=>'separatorAfter'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'0'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Adds a visual gap after every N boxes, for example 3 shows a code as 123 456. Choose None for an unbroken row. This is only for display and is not part of the stored value.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15975204533198100)
,p_plugin_attribute_id=>wwv_flow_imp.id(15974301779195265)
,p_display_sequence=>20
,p_display_value=>'2'
,p_return_value=>'2'
,p_apexlang_name=>'2'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15976886434204177)
,p_plugin_attribute_id=>wwv_flow_imp.id(15974301779195265)
,p_display_sequence=>30
,p_display_value=>'3'
,p_return_value=>'3'
,p_apexlang_name=>'3'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15977251292204546)
,p_plugin_attribute_id=>wwv_flow_imp.id(15974301779195265)
,p_display_sequence=>40
,p_display_value=>'4'
,p_return_value=>'4'
,p_apexlang_name=>'4'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15974874254197161)
,p_plugin_attribute_id=>wwv_flow_imp.id(15974301779195265)
,p_display_sequence=>10
,p_display_value=>'None'
,p_return_value=>'0'
,p_apexlang_name=>'none'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15981556203235172)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_static_id=>'size'
,p_prompt=>'Size'
,p_apexlang_name=>'size'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'MEDIUM'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Size of the boxes: Small, Medium or Large.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15982847434237492)
,p_plugin_attribute_id=>wwv_flow_imp.id(15981556203235172)
,p_display_sequence=>30
,p_display_value=>'Large'
,p_return_value=>'LARGE'
,p_apexlang_name=>'large'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15982416510236730)
,p_plugin_attribute_id=>wwv_flow_imp.id(15981556203235172)
,p_display_sequence=>20
,p_display_value=>'Medium'
,p_return_value=>'MEDIUM'
,p_apexlang_name=>'medium'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15982039377236114)
,p_plugin_attribute_id=>wwv_flow_imp.id(15981556203235172)
,p_display_sequence=>10
,p_display_value=>'Small'
,p_return_value=>'SMALL'
,p_apexlang_name=>'small'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(15983732270242703)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_static_id=>'style'
,p_prompt=>'Style'
,p_apexlang_name=>'style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'BOXED'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Look of the boxes: Boxed, Rounded or Underline.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15984280536244284)
,p_plugin_attribute_id=>wwv_flow_imp.id(15983732270242703)
,p_display_sequence=>10
,p_display_value=>'Boxed'
,p_return_value=>'BOXED'
,p_apexlang_name=>'boxed'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15984636888245058)
,p_plugin_attribute_id=>wwv_flow_imp.id(15983732270242703)
,p_display_sequence=>20
,p_display_value=>'Rounded'
,p_return_value=>'ROUNDED'
,p_apexlang_name=>'rounded'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(15985031057245624)
,p_plugin_attribute_id=>wwv_flow_imp.id(15983732270242703)
,p_display_sequence=>30
,p_display_value=>'Underline'
,p_return_value=>'UNDERLINE'
,p_apexlang_name=>'underline'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204F7470496E70757420302E312E30202D20434F4D5F43454D534D5F4F54505F494E5055';
wwv_flow_imp.g_varchar2_table(2) := '540D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(3) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204F545020494E5055540D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(4) := '3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F7470207B0D0A202020202D2D6F74702D626F726465723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D6669656C642D696E7075742D626F72646572';
wwv_flow_imp.g_varchar2_table(5) := '2D636F6C6F722C0D0A202020202020202020202020766172282D2D75742D6669656C642D696E7075742D626F726465722D636F6C6F722C2023386639353965290D0A2020202020202020293B0D0A0D0A202020202D2D6F74702D62673A0D0A2020202020';
wwv_flow_imp.g_varchar2_table(6) := '202020766172280D0A2020202020202020202020202D2D612D6669656C642D696E7075742D6261636B67726F756E642D636F6C6F722C0D0A202020202020202020202020766172282D2D75742D6669656C642D696E7075742D6261636B67726F756E642D';
wwv_flow_imp.g_varchar2_table(7) := '636F6C6F722C2023666666666666290D0A2020202020202020293B0D0A0D0A202020202D2D6F74702D746578743A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D6669656C642D696E7075742D746578742D636F6C6F72';
wwv_flow_imp.g_varchar2_table(8) := '2C0D0A202020202020202020202020766172282D2D75742D6669656C642D696E7075742D746578742D636F6C6F722C20696E6865726974290D0A2020202020202020293B0D0A0D0A202020202D2D6F74702D616363656E743A0D0A202020202020202076';
wwv_flow_imp.g_varchar2_table(9) := '6172280D0A2020202020202020202020202D2D612D70616C657474652D7072696D6172792C0D0A202020202020202020202020766172282D2D75742D70616C657474652D7072696D6172792C2023303537326365290D0A2020202020202020293B0D0A0D';
wwv_flow_imp.g_varchar2_table(10) := '0A202020202D2D6F74702D64616E6765723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D70616C657474652D64616E6765722C0D0A202020202020202020202020766172282D2D75742D70616C657474652D64616E67';
wwv_flow_imp.g_varchar2_table(11) := '65722C2023643933303235290D0A2020202020202020293B0D0A0D0A202020202D2D6F74702D73697A653A202020322E373572656D3B0D0A202020202D2D6F74702D666F6E743A202020312E323572656D3B0D0A202020202D2D6F74702D726164697573';
wwv_flow_imp.g_varchar2_table(12) := '3A20302E33373572656D3B0D0A202020202D2D6F74702D6761703A20202020302E3572656D3B0D0A0D0A20202020646973706C61793A20696E6C696E652D666C65783B0D0A20202020666C65782D777261703A206E6F777261703B0D0A20202020616C69';
wwv_flow_imp.g_varchar2_table(13) := '676E2D6974656D733A2063656E7465723B0D0A202020206A7573746966792D636F6E74656E743A2063656E7465723B0D0A0D0A202020206761703A20766172282D2D6F74702D676170293B0D0A0D0A202020206D61782D77696474683A20313030253B0D';
wwv_flow_imp.g_varchar2_table(14) := '0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202053495A45530D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(15) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D2D736D616C6C207B0D0A202020202D2D6F74702D73697A653A20322E323572656D3B0D0A2020';
wwv_flow_imp.g_varchar2_table(16) := '20202D2D6F74702D666F6E743A203172656D3B0D0A7D0D0A0D0A2E636F6D2D63656D736D2D6F74702D2D6D656469756D207B0D0A202020202D2D6F74702D73697A653A20322E373572656D3B0D0A202020202D2D6F74702D666F6E743A20312E32357265';
wwv_flow_imp.g_varchar2_table(17) := '6D3B0D0A7D0D0A0D0A2E636F6D2D63656D736D2D6F74702D2D6C61726765207B0D0A202020202D2D6F74702D73697A653A20332E3572656D3B0D0A202020202D2D6F74702D666F6E743A20312E36323572656D3B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D';
wwv_flow_imp.g_varchar2_table(18) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204F545020424F580D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(19) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74705F5F626F78207B0D0A20202020626F782D73697A696E673A20626F726465722D626F783B0D0A0D0A2020202077696474683A2076';
wwv_flow_imp.g_varchar2_table(20) := '6172282D2D6F74702D73697A65293B0D0A202020206865696768743A20766172282D2D6F74702D73697A65293B0D0A202020206D696E2D77696474683A20303B0D0A0D0A202020202F2A0D0A20202020202A204B65657073206E756D62657273202F2062';
wwv_flow_imp.g_varchar2_table(21) := '756C6C6574732076697375616C6C792063656E74657265642E0D0A20202020202A2F0D0A2020202070616464696E673A203020302034707820303B0D0A0D0A20202020666C65783A20302031206175746F3B0D0A0D0A20202020746578742D616C69676E';
wwv_flow_imp.g_varchar2_table(22) := '3A2063656E7465723B0D0A0D0A20202020666F6E742D73697A653A20766172282D2D6F74702D666F6E74293B0D0A20202020666F6E742D7765696768743A203630303B0D0A202020206C696E652D6865696768743A206E6F726D616C3B0D0A0D0A202020';
wwv_flow_imp.g_varchar2_table(23) := '20636F6C6F723A20766172282D2D6F74702D74657874293B0D0A202020206261636B67726F756E643A20766172282D2D6F74702D6267293B0D0A0D0A20202020626F726465723A2031707820736F6C696420766172282D2D6F74702D626F72646572293B';
wwv_flow_imp.g_varchar2_table(24) := '0D0A20202020626F726465722D7261646975733A20766172282D2D6F74702D726164697573293B0D0A0D0A2020202063617265742D636F6C6F723A20766172282D2D6F74702D616363656E74293B0D0A0D0A202020207472616E73666F726D3A0D0A2020';
wwv_flow_imp.g_varchar2_table(25) := '2020202020207472616E736C617465592830290D0A20202020202020207363616C652831293B0D0A0D0A202020207472616E73666F726D2D6F726967696E3A2063656E7465723B0D0A0D0A202020207472616E736974696F6E3A0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(26) := '7472616E73666F726D20302E3332732063756269632D62657A69657228302E32322C20312C20302E33362C2031292C0D0A2020202020202020626F782D736861646F7720302E3332732063756269632D62657A69657228302E32322C20312C20302E3336';
wwv_flow_imp.g_varchar2_table(27) := '2C2031292C0D0A2020202020202020626F726465722D636F6C6F7220302E32347320656173652C0D0A20202020202020206261636B67726F756E642D636F6C6F7220302E32347320656173652C0D0A20202020202020206F70616369747920302E323473';
wwv_flow_imp.g_varchar2_table(28) := '20656173653B0D0A0D0A2020202077696C6C2D6368616E67653A0D0A20202020202020207472616E73666F726D2C0D0A2020202020202020626F782D736861646F773B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(29) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020534550415241544F52204741500D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(30) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74705F5F626F782D2D676170207B0D0A202020206D617267696E2D696E6C696E652D656E643A2063616C6328766172282D2D6F74702D67617029202A20312E3529';
wwv_flow_imp.g_varchar2_table(31) := '3B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020484F5645520D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(32) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A686F7665723A6E6F74283A666F63757329207B0D0A20202020626F72646572';
wwv_flow_imp.g_varchar2_table(33) := '2D636F6C6F723A0D0A2020202020202020636F6C6F722D6D6978280D0A202020202020202020202020696E20737267622C0D0A202020202020202020202020766172282D2D6F74702D616363656E7429203630252C0D0A20202020202020202020202076';
wwv_flow_imp.g_varchar2_table(34) := '6172282D2D6F74702D626F72646572290D0A2020202020202020293B0D0A0D0A202020207472616E73666F726D3A0D0A20202020202020207472616E736C61746559282D317078290D0A20202020202020207363616C6528312E303135293B0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(35) := '202020626F782D736861646F773A0D0A2020202020202020302034707820387078207267626128302C20302C20302C20302E3036292C0D0A202020202020202030203770782031367078207267626128302C20302C20302C20302E3035293B0D0A7D0D0A';
wwv_flow_imp.g_varchar2_table(36) := '0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020464F43555320414E494D4154494F4E0D0A2020203D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(37) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A406B65796672616D6573206F74702D666F6375732D696E207B0D0A0D0A202020203025207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(38) := '7472616E73666F726D3A0D0A2020202020202020202020207472616E736C617465592830290D0A2020202020202020202020207363616C652831293B0D0A202020207D0D0A0D0A20202020353525207B0D0A20202020202020207472616E73666F726D3A';
wwv_flow_imp.g_varchar2_table(39) := '0D0A2020202020202020202020207472616E736C61746559282D367078290D0A2020202020202020202020207363616C6528312E303735293B0D0A202020207D0D0A0D0A20202020373825207B0D0A20202020202020207472616E73666F726D3A0D0A20';
wwv_flow_imp.g_varchar2_table(40) := '20202020202020202020207472616E736C61746559282D337078290D0A2020202020202020202020207363616C6528312E303435293B0D0A202020207D0D0A0D0A2020202031303025207B0D0A20202020202020207472616E73666F726D3A0D0A202020';
wwv_flow_imp.g_varchar2_table(41) := '2020202020202020207472616E736C61746559282D347078290D0A2020202020202020202020207363616C6528312E3036293B0D0A202020207D0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(42) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020464F4355530D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20';
wwv_flow_imp.g_varchar2_table(43) := '2A2F0D0A0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A666F637573207B0D0A202020206F75746C696E653A206E6F6E653B0D0A0D0A20202020626F726465722D636F6C6F723A20766172282D2D6F74702D616363656E74293B0D0A0D0A202020';
wwv_flow_imp.g_varchar2_table(44) := '207472616E73666F726D3A0D0A20202020202020207472616E736C61746559282D347078290D0A20202020202020207363616C6528312E3036293B0D0A0D0A202020202F2A0D0A20202020202A204D756C7469706C6520736861646F77206C6179657273';
wwv_flow_imp.g_varchar2_table(45) := '206372656174653A0D0A20202020202A20312E20416363656E742072696E670D0A20202020202A20322E20436C6F736520676C6F770D0A20202020202A20332E205769646520676C6F770D0A20202020202A20342E20466C6F6174696E6720736861646F';
wwv_flow_imp.g_varchar2_table(46) := '770D0A20202020202A20352E204465657020636F6E7461637420736861646F770D0A20202020202A2F0D0A20202020626F782D736861646F773A0D0A0D0A20202020202020203020302030203370780D0A2020202020202020636F6C6F722D6D6978280D';
wwv_flow_imp.g_varchar2_table(47) := '0A202020202020202020202020696E20737267622C0D0A202020202020202020202020766172282D2D6F74702D616363656E7429203232252C0D0A2020202020202020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(48) := '20202020202030203020313270780D0A2020202020202020636F6C6F722D6D6978280D0A202020202020202020202020696E20737267622C0D0A202020202020202020202020766172282D2D6F74702D616363656E7429203234252C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(49) := '2020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A202020202020202030203020323870780D0A2020202020202020636F6C6F722D6D6978280D0A202020202020202020202020696E20737267622C0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(50) := '2020202020766172282D2D6F74702D616363656E7429203136252C0D0A2020202020202020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A202020202020202030203134707820323870780D0A2020202020202020726762';
wwv_flow_imp.g_varchar2_table(51) := '6128302C20302C20302C20302E3137292C0D0A0D0A2020202020202020302036707820313270780D0A20202020202020207267626128302C20302C20302C20302E3131293B0D0A0D0A20202020616E696D6174696F6E3A0D0A20202020202020206F7470';
wwv_flow_imp.g_varchar2_table(52) := '2D666F6375732D696E0D0A2020202020202020302E3432730D0A202020202020202063756269632D62657A69657228302E32322C20312C20302E33362C2031293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(53) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202044494D204E4F4E2D464F435553454420424F5845530D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(54) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74703A666F6375732D77697468696E0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A6E6F74283A666F63757329207B0D0A202020206F7061';
wwv_flow_imp.g_varchar2_table(55) := '636974793A20302E38383B0D0A0D0A202020207472616E73666F726D3A0D0A20202020202020207472616E736C617465592830290D0A20202020202020207363616C6528302E393835293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(56) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202046494C4C45440D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(57) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74705F5F626F782E69732D66696C6C6564207B0D0A20202020626F726465722D636F6C6F723A0D0A2020202020202020636F6C6F722D6D6978280D0A20202020';
wwv_flow_imp.g_varchar2_table(58) := '2020202020202020696E20737267622C0D0A202020202020202020202020766172282D2D6F74702D616363656E7429203735252C0D0A202020202020202020202020766172282D2D6F74702D626F72646572290D0A2020202020202020293B0D0A7D0D0A';
wwv_flow_imp.g_varchar2_table(59) := '0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020494E505554205354594C45530D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(60) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A0D0A2F2A20526F756E646564202F20436972636C65202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D2D726F756E6465';
wwv_flow_imp.g_varchar2_table(61) := '64202E636F6D2D63656D736D2D6F74705F5F626F78207B0D0A202020202D2D6F74702D7261646975733A2039393970783B0D0A7D0D0A0D0A0D0A2F2A20556E6465726C696E65202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D2D756E6465726C69';
wwv_flow_imp.g_varchar2_table(62) := '6E65202E636F6D2D63656D736D2D6F74705F5F626F78207B0D0A202020206261636B67726F756E643A207472616E73706172656E743B0D0A0D0A20202020626F726465722D77696474683A203020302032707820303B0D0A20202020626F726465722D72';
wwv_flow_imp.g_varchar2_table(63) := '61646975733A20303B0D0A7D0D0A0D0A0D0A2F2A0D0A202A20556E6465726C696E65207374796C65206B6565707320746865206D6F76656D656E742C0D0A202A2062757420646F65736E27742075736520746865206C6172676520666C6F6174696E6720';
wwv_flow_imp.g_varchar2_table(64) := '736861646F772E0D0A202A2F0D0A2E636F6D2D63656D736D2D6F74702D2D756E6465726C696E65202E636F6D2D63656D736D2D6F74705F5F626F783A666F637573207B0D0A20202020626F782D736861646F773A0D0A2020202020202020302035707820';
wwv_flow_imp.g_varchar2_table(65) := '31307078207267626128302C20302C20302C20302E3036293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204D';
wwv_flow_imp.g_varchar2_table(66) := '41494E20434F4D504F4E454E5420434F4E5441494E45520D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D';
wwv_flow_imp.g_varchar2_table(67) := '736D2D6F74702D77726170706572207B0D0A202020202D2D6F74702D636F6E7461696E65722D62673A20236631663266343B0D0A0D0A20202020706F736974696F6E3A2072656C61746976653B0D0A0D0A20202020646973706C61793A20696E6C696E65';
wwv_flow_imp.g_varchar2_table(68) := '2D666C65783B0D0A20202020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A0D0A202020206D696E2D77696474683A20323272656D3B0D0A202020206D61782D77696474683A20313030253B0D0A0D0A2020202070616464696E673A2030';
wwv_flow_imp.g_varchar2_table(69) := '3B0D0A202020206D617267696E2D746F703A20302E3572656D3B0D0A0D0A202020206261636B67726F756E643A20766172282D2D6F74702D636F6E7461696E65722D6267293B0D0A0D0A20202020626F726465723A0D0A20202020202020203170782073';
wwv_flow_imp.g_varchar2_table(70) := '6F6C69640D0A2020202020202020766172280D0A2020202020202020202020202D2D612D6669656C642D696E7075742D626F726465722D636F6C6F722C0D0A202020202020202020202020766172282D2D75742D6669656C642D696E7075742D626F7264';
wwv_flow_imp.g_varchar2_table(71) := '65722D636F6C6F722C2023386639353965290D0A2020202020202020293B0D0A0D0A20202020626F726465722D7261646975733A20302E373572656D3B0D0A0D0A202020206F766572666C6F773A2068696464656E3B0D0A7D0D0A0D0A0D0A2F2A203D3D';
wwv_flow_imp.g_varchar2_table(72) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204845414445520D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(73) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D686561646572207B0D0A20202020706F736974696F6E3A2072656C61746976653B0D0A0D0A2020202069736F6C6174696F6E';
wwv_flow_imp.g_varchar2_table(74) := '3A2069736F6C6174653B0D0A202020206F766572666C6F773A2068696464656E3B0D0A0D0A2020202077696474683A20313030253B0D0A202020206D696E2D6865696768743A203772656D3B0D0A0D0A20202020646973706C61793A20666C65783B0D0A';
wwv_flow_imp.g_varchar2_table(75) := '20202020616C69676E2D6974656D733A2063656E7465723B0D0A202020206A7573746966792D636F6E74656E743A2063656E7465723B0D0A0D0A202020206261636B67726F756E643A0D0A2020202020202020636F6C6F722D6D6978280D0A2020202020';
wwv_flow_imp.g_varchar2_table(76) := '20202020202020696E20737267622C0D0A202020202020202020202020766172280D0A202020202020202020202020202020202D2D612D70616C657474652D7072696D6172792C0D0A20202020202020202020202020202020766172282D2D75742D7061';
wwv_flow_imp.g_varchar2_table(77) := '6C657474652D7072696D6172792C2023303537326365290D0A20202020202020202020202029203132252C0D0A202020202020202020202020766172282D2D6F74702D636F6E7461696E65722D6267290D0A2020202020202020293B0D0A7D0D0A0D0A0D';
wwv_flow_imp.g_varchar2_table(78) := '0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A202020535542544C45204D4F56494E47205345435552495459205041545445524E0D0A2020';
wwv_flow_imp.g_varchar2_table(79) := '203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D6865616465723A3A6265666F7265207B0D0A2020';
wwv_flow_imp.g_varchar2_table(80) := '2020636F6E74656E743A0D0A202020202020202022E280A220203720202A2020E280A22020332020E280A220202A2020392020E280A220203120202A2020E280A22020362020E280A220202A2020342020E280A22020220D0A202020202020202022E280';
wwv_flow_imp.g_varchar2_table(81) := 'A220203220202A2020E280A22020382020E280A220202A2020352020E280A220203020202A2020E280A22020372020E280A220202A2020332020E280A2223B0D0A0D0A20202020706F736974696F6E3A206162736F6C7574653B0D0A0D0A20202020746F';
wwv_flow_imp.g_varchar2_table(82) := '703A203530253B0D0A202020206C6566743A202D3130253B0D0A0D0A2020202077696474683A20313230253B0D0A0D0A202020207472616E73666F726D3A0D0A20202020202020207472616E736C617465282D32252C202D353025293B0D0A0D0A202020';
wwv_flow_imp.g_varchar2_table(83) := '20666F6E742D73697A653A20312E313572656D3B0D0A20202020666F6E742D7765696768743A203630303B0D0A202020206C696E652D6865696768743A20322E353B0D0A0D0A202020206C65747465722D73706163696E673A20302E3872656D3B0D0A0D';
wwv_flow_imp.g_varchar2_table(84) := '0A2020202077686974652D73706163653A206E6F726D616C3B0D0A0D0A20202020636F6C6F723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D70616C657474652D7072696D6172792C0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(85) := '20766172282D2D75742D70616C657474652D7072696D6172792C2023303537326365290D0A2020202020202020293B0D0A0D0A202020206F7061636974793A20302E30373B0D0A0D0A20202020706F696E7465722D6576656E74733A206E6F6E653B0D0A';
wwv_flow_imp.g_varchar2_table(86) := '20202020757365722D73656C6563743A206E6F6E653B0D0A0D0A20202020616E696D6174696F6E3A0D0A20202020202020206F74702D7061747465726E2D6D6F76650D0A20202020202020203138730D0A20202020202020206C696E6561720D0A202020';
wwv_flow_imp.g_varchar2_table(87) := '2020202020696E66696E6974653B0D0A0D0A202020207A2D696E6465783A202D313B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(88) := '3D3D3D0D0A202020484541444552205041545445524E20414E494D4154494F4E0D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D';
wwv_flow_imp.g_varchar2_table(89) := '0A406B65796672616D6573206F74702D7061747465726E2D6D6F7665207B0D0A0D0A2020202066726F6D207B0D0A20202020202020207472616E73666F726D3A0D0A2020202020202020202020207472616E736C617465282D32252C202D353025293B0D';
wwv_flow_imp.g_varchar2_table(90) := '0A202020207D0D0A0D0A20202020746F207B0D0A20202020202020207472616E73666F726D3A0D0A2020202020202020202020207472616E736C6174652836252C202D353025293B0D0A202020207D0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(91) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204845414445522049434F4E0D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(92) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702D6865616465725F5F69636F6E207B0D0A20202020706F736974696F6E3A2072656C61746976653B0D0A202020207A2D696E646578';
wwv_flow_imp.g_varchar2_table(93) := '3A20323B0D0A0D0A2020202077696474683A20342E3572656D3B0D0A202020206865696768743A20342E3572656D3B0D0A0D0A20202020646973706C61793A20696E6C696E652D666C65782021696D706F7274616E743B0D0A20202020616C69676E2D69';
wwv_flow_imp.g_varchar2_table(94) := '74656D733A2063656E7465722021696D706F7274616E743B0D0A202020206A7573746966792D636F6E74656E743A2063656E7465722021696D706F7274616E743B0D0A0D0A20202020626F782D73697A696E673A20626F726465722D626F783B0D0A0D0A';
wwv_flow_imp.g_varchar2_table(95) := '2020202070616464696E673A20303B0D0A202020206D617267696E3A20303B0D0A0D0A20202020666F6E742D73697A653A20322E333572656D3B0D0A202020206C696E652D6865696768743A20312021696D706F7274616E743B0D0A0D0A20202020636F';
wwv_flow_imp.g_varchar2_table(96) := '6C6F723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D70616C657474652D7072696D6172792C0D0A202020202020202020202020766172282D2D75742D70616C657474652D7072696D6172792C202330353732636529';
wwv_flow_imp.g_varchar2_table(97) := '0D0A2020202020202020293B0D0A0D0A202020206261636B67726F756E643A0D0A202020202020202072676261283235352C203235352C203235352C20302E3535293B0D0A0D0A20202020626F726465723A0D0A202020202020202031707820736F6C69';
wwv_flow_imp.g_varchar2_table(98) := '640D0A202020202020202072676261283235352C203235352C203235352C20302E37293B0D0A0D0A20202020626F726465722D7261646975733A203530253B0D0A0D0A20202020626F782D736861646F773A0D0A20202020202020203020367078203138';
wwv_flow_imp.g_varchar2_table(99) := '70780D0A20202020202020207267626128302C20302C20302C20302E3036293B0D0A0D0A202020206261636B64726F702D66696C7465723A0D0A2020202020202020626C757228347078293B0D0A0D0A202020202D7765626B69742D6261636B64726F70';
wwv_flow_imp.g_varchar2_table(100) := '2D66696C7465723A0D0A2020202020202020626C757228347078293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20';
wwv_flow_imp.g_varchar2_table(101) := '2020464F4E5420415045582049434F4E20414C49474E4D454E540D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D';
wwv_flow_imp.g_varchar2_table(102) := '63656D736D2D6F74702D6865616465725F5F69636F6E3A3A6265666F7265207B0D0A20202020646973706C61793A20626C6F636B3B0D0A0D0A202020206D617267696E3A20303B0D0A2020202070616464696E673A20303B0D0A0D0A202020206C696E65';
wwv_flow_imp.g_varchar2_table(103) := '2D6865696768743A20312021696D706F7274616E743B0D0A0D0A202020202F2A0D0A20202020202A204F70746963616C20636F7272656374696F6E20666F7220466F6E7420415045582069636F6E732E0D0A20202020202A2F0D0A202020207472616E73';
wwv_flow_imp.g_varchar2_table(104) := '666F726D3A0D0A20202020202020207472616E736C61746559282D317078293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(105) := '3D0D0A202020434F4D504F4E454E5420424F44590D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D';
wwv_flow_imp.g_varchar2_table(106) := '6F74702D626F6479207B0D0A20202020646973706C61793A20666C65783B0D0A20202020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A20202020616C69676E2D6974656D733A2063656E7465723B0D0A0D0A2020202077696474683A20';
wwv_flow_imp.g_varchar2_table(107) := '313030253B0D0A0D0A20202020626F782D73697A696E673A20626F726465722D626F783B0D0A0D0A2020202070616464696E673A0D0A2020202020202020312E3472656D0D0A2020202020202020312E3572656D0D0A2020202020202020312E3572656D';
wwv_flow_imp.g_varchar2_table(108) := '3B0D0A0D0A202020206261636B67726F756E643A0D0A2020202020202020766172282D2D6F74702D636F6E7461696E65722D6267293B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(109) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020205449544C450D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A';
wwv_flow_imp.g_varchar2_table(110) := '0D0A2E636F6D2D63656D736D2D6F74702D7469746C65207B0D0A202020206D617267696E2D626F74746F6D3A203172656D3B0D0A0D0A20202020666F6E742D73697A653A20302E393572656D3B0D0A20202020666F6E742D7765696768743A203630303B';
wwv_flow_imp.g_varchar2_table(111) := '0D0A202020206C696E652D6865696768743A20312E333B0D0A0D0A20202020636F6C6F723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D6669656C642D696E7075742D746578742D636F6C6F722C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(112) := '202020202020766172282D2D75742D6669656C642D696E7075742D746578742D636F6C6F722C20696E6865726974290D0A2020202020202020293B0D0A0D0A20202020746578742D616C69676E3A2063656E7465723B0D0A0D0A202020206C6574746572';
wwv_flow_imp.g_varchar2_table(113) := '2D73706163696E673A20302E3032656D3B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020204552524F5220535441';
wwv_flow_imp.g_varchar2_table(114) := '54450D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E617065782D706167652D6974656D2D6572726F720D0A2B202E636F6D';
wwv_flow_imp.g_varchar2_table(115) := '2D63656D736D2D6F74702D777261707065720D0A2E636F6D2D63656D736D2D6F74705F5F626F78207B0D0A20202020626F726465722D636F6C6F723A0D0A2020202020202020766172280D0A2020202020202020202020202D2D612D70616C657474652D';
wwv_flow_imp.g_varchar2_table(116) := '64616E6765722C0D0A202020202020202020202020766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A2020202020202020293B0D0A7D0D0A0D0A0D0A2F2A204572726F72202B20466F637573202A2F0D0A0D0A2E61';
wwv_flow_imp.g_varchar2_table(117) := '7065782D706167652D6974656D2D6572726F720D0A2B202E636F6D2D63656D736D2D6F74702D777261707065720D0A2E636F6D2D63656D736D2D6F74705F5F626F783A666F637573207B0D0A20202020626F726465722D636F6C6F723A0D0A2020202020';
wwv_flow_imp.g_varchar2_table(118) := '202020766172280D0A2020202020202020202020202D2D612D70616C657474652D64616E6765722C0D0A202020202020202020202020766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A2020202020202020293B0D';
wwv_flow_imp.g_varchar2_table(119) := '0A0D0A20202020626F782D736861646F773A0D0A0D0A20202020202020203020302030203370780D0A2020202020202020636F6C6F722D6D6978280D0A202020202020202020202020696E20737267622C0D0A202020202020202020202020766172280D';
wwv_flow_imp.g_varchar2_table(120) := '0A202020202020202020202020202020202D2D612D70616C657474652D64616E6765722C0D0A20202020202020202020202020202020766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(121) := '2029203232252C0D0A2020202020202020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A202020202020202030203020313470780D0A2020202020202020636F6C6F722D6D6978280D0A202020202020202020202020696E';
wwv_flow_imp.g_varchar2_table(122) := '20737267622C0D0A202020202020202020202020766172280D0A202020202020202020202020202020202D2D612D70616C657474652D64616E6765722C0D0A20202020202020202020202020202020766172282D2D75742D70616C657474652D64616E67';
wwv_flow_imp.g_varchar2_table(123) := '65722C2023643933303235290D0A20202020202020202020202029203232252C0D0A2020202020202020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A202020202020202030203020323870780D0A202020202020202063';
wwv_flow_imp.g_varchar2_table(124) := '6F6C6F722D6D6978280D0A202020202020202020202020696E20737267622C0D0A202020202020202020202020766172280D0A202020202020202020202020202020202D2D612D70616C657474652D64616E6765722C0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(125) := '20202020766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A20202020202020202020202029203134252C0D0A2020202020202020202020207472616E73706172656E740D0A2020202020202020292C0D0A0D0A2020';
wwv_flow_imp.g_varchar2_table(126) := '20202020202030203134707820323870780D0A20202020202020207267626128302C20302C20302C20302E3137292C0D0A0D0A2020202020202020302036707820313270780D0A20202020202020207267626128302C20302C20302C20302E3131293B0D';
wwv_flow_imp.g_varchar2_table(127) := '0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202044495341424C45442053544154450D0A2020203D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(128) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E636F6D2D63656D736D2D6F74702E69732D64697361626C6564207B0D0A202020206F7061636974793A2030';
wwv_flow_imp.g_varchar2_table(129) := '2E363B0D0A7D0D0A0D0A0D0A2E636F6D2D63656D736D2D6F74702E69732D64697361626C65640D0A2E636F6D2D63656D736D2D6F74705F5F626F78207B0D0A20202020637572736F723A206E6F742D616C6C6F7765643B0D0A0D0A202020207472616E73';
wwv_flow_imp.g_varchar2_table(130) := '666F726D3A206E6F6E653B0D0A0D0A20202020626F782D736861646F773A206E6F6E653B0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(131) := '3D3D3D3D3D0D0A202020524553504F4E534956450D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A406D6564696120286D6178';
wwv_flow_imp.g_varchar2_table(132) := '2D77696474683A20343830707829207B0D0A0D0A202020202E636F6D2D63656D736D2D6F74702D77726170706572207B0D0A20202020202020206D696E2D77696474683A20303B0D0A202020202020202077696474683A20313030253B0D0A202020207D';
wwv_flow_imp.g_varchar2_table(133) := '0D0A0D0A0D0A202020202E636F6D2D63656D736D2D6F74702D626F6479207B0D0A202020202020202070616464696E673A0D0A202020202020202020202020312E323572656D0D0A202020202020202020202020302E373572656D0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(134) := '2020202020312E333572656D3B0D0A202020207D0D0A0D0A0D0A202020202E636F6D2D63656D736D2D6F74702D2D6C61726765207B0D0A20202020202020202D2D6F74702D73697A653A20322E373572656D3B0D0A20202020202020202D2D6F74702D66';
wwv_flow_imp.g_varchar2_table(135) := '6F6E743A20312E323572656D3B0D0A202020207D0D0A0D0A0D0A202020202E636F6D2D63656D736D2D6F7470207B0D0A20202020202020202D2D6F74702D6761703A20302E33373572656D3B0D0A202020207D0D0A7D0D0A0D0A0D0A2F2A203D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(136) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202052454455434544204D4F54494F4E202F204143434553534942494C4954590D0A2020203D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(137) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A406D656469612028707265666572732D726564756365642D6D6F74696F6E3A2072656475636529207B0D0A0D';
wwv_flow_imp.g_varchar2_table(138) := '0A202020202E636F6D2D63656D736D2D6F74705F5F626F782C0D0A202020202E636F6D2D63656D736D2D6F74705F5F626F783A686F7665722C0D0A202020202E636F6D2D63656D736D2D6F74705F5F626F783A666F6375732C0D0A202020202E636F6D2D';
wwv_flow_imp.g_varchar2_table(139) := '63656D736D2D6F74703A666F6375732D77697468696E0D0A202020202E636F6D2D63656D736D2D6F74705F5F626F783A6E6F74283A666F63757329207B0D0A2020202020202020616E696D6174696F6E3A206E6F6E653B0D0A2020202020202020747261';
wwv_flow_imp.g_varchar2_table(140) := '6E736974696F6E3A206E6F6E653B0D0A0D0A20202020202020207472616E73666F726D3A206E6F6E653B0D0A202020207D0D0A0D0A0D0A202020202E636F6D2D63656D736D2D6F74702D6865616465723A3A6265666F7265207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(141) := '616E696D6174696F6E3A206E6F6E653B0D0A202020207D0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(15985808646266455)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_file_name=>'otp-input.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A204F7470496E70757420302E312E30202D20434F4D5F43454D534D5F4F54505F494E5055540D0A202A2043616C6C6564206279207468652072656E6465722070726F6365647572653A204F7470496E7075742E6D6F756E74286974656D4E616D652C';
wwv_flow_imp.g_varchar2_table(2) := '20636F6E666967290D0A202A2048696464656E20696E70757420203A20234954454D202020202020202028686F6C6473207468652066756C6C20636F64652C20746865207265616C2070616765206974656D290D0A202A20436F6E7461696E6572202020';
wwv_flow_imp.g_varchar2_table(3) := '20203A20234954454D5F4F54502020202028626F78657320617265206275696C7420696E73696465206974290D0A202A20426F7865732020202020202020203A20234954454D5F30202E2E2E20234954454D5F286C656E6774682D31290D0A202A204576';
wwv_flow_imp.g_varchar2_table(4) := '656E747320202020202020203A206F74702D6368616E67652C206F74702D636F6D706C6574652028747269676765726564206F6E20234954454D290D0A202A2F0D0A2866756E6374696F6E2028617065782C202429207B0D0A2020202022757365207374';
wwv_flow_imp.g_varchar2_table(5) := '72696374223B0D0A0D0A202020207661722042554C4C4554203D20225C7532303232223B0D0A20202020766172205041545445524E53203D207B0D0A20202020202020206E756D657269633A2020202020202F5B302D395D2F2C0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(6) := '616C7068616E756D657269633A202F5B412D5A612D7A302D395D2F2C0D0A2020202020202020616E793A202020202020202020202F5C532F0D0A202020207D3B0D0A0D0A202020202F2F205065727369616E2028552B303646302E2E2920616E64204172';
wwv_flow_imp.g_varchar2_table(7) := '616269632D496E6469632028552B303636302E2E2920646967697473202D3E204153434949206469676974730D0A2020202066756E6374696F6E206E6F726D616C697A65446967697428636829207B0D0A20202020202020207661722063203D2063682E';
wwv_flow_imp.g_varchar2_table(8) := '63686172436F646541742830293B0D0A20202020202020206966202863203E3D203078303646302026262063203C3D2030783036463929207B2072657475726E20537472696E672E66726F6D43686172436F64652863202D20307830364630202B203438';
wwv_flow_imp.g_varchar2_table(9) := '293B207D0D0A20202020202020206966202863203E3D203078303636302026262063203C3D2030783036363929207B2072657475726E20537472696E672E66726F6D43686172436F64652863202D20307830363630202B203438293B207D0D0A20202020';
wwv_flow_imp.g_varchar2_table(10) := '2020202072657475726E2063683B0D0A202020207D0D0A0D0A2020202066756E6374696F6E206D6F756E74286974656D4E616D652C2063666729207B0D0A20202020202020207661722068696464656E203D20646F63756D656E742E676574456C656D65';
wwv_flow_imp.g_varchar2_table(11) := '6E7442794964286974656D4E616D65293B0D0A202020202020202076617220726F6F742020203D20646F63756D656E742E676574456C656D656E7442794964286974656D4E616D65202B20225F4F545022293B0D0A202020202020202069662028216869';
wwv_flow_imp.g_varchar2_table(12) := '6464656E207C7C2021726F6F7429207B2072657475726E3B207D0D0A0D0A2020202020202020766172206C656E202020202020203D206366672E6C656E6774683B0D0A202020202020202076617220616C6C6F7765642020203D205041545445524E535B';
wwv_flow_imp.g_varchar2_table(13) := '6366672E696E707574547970655D207C7C205041545445524E532E6E756D657269633B0D0A20202020202020207661722069734E756D65726963203D206366672E696E70757454797065203D3D3D20226E756D65726963223B0D0A202020202020202076';
wwv_flow_imp.g_varchar2_table(14) := '617220636861727320202020203D205B5D3B2020202F2F20616C7761797320612066696C6C6564207072656669782C206E657665722068617320676170730D0A202020202020202076617220626F78657320202020203D205B5D3B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(15) := '2076617220696E697469616C2020203D2022223B0D0A2020202020202020766172207375626D6974746564203D2066616C73653B0D0A0D0A20202020202020202F2F204B656570206F6E6C7920616C6C6F77656420636861726163746572732C20617320';
wwv_flow_imp.g_varchar2_table(16) := '616E2061727261790D0A202020202020202066756E6374696F6E20636C65616E287465787429207B0D0A202020202020202020202020766172206F7574203D205B5D3B0D0A20202020202020202020202041727261792E66726F6D28537472696E672874';
wwv_flow_imp.g_varchar2_table(17) := '657874203D3D3D206E756C6C207C7C2074657874203D3D3D20756E646566696E6564203F202222203A207465787429292E666F72456163682866756E6374696F6E2028636829207B0D0A20202020202020202020202020202020696620286366672E696E';
wwv_flow_imp.g_varchar2_table(18) := '7075745479706520213D3D2022616E792229207B206368203D206E6F726D616C697A654469676974286368293B207D0D0A2020202020202020202020202020202069662028616C6C6F7765642E746573742863682929207B206F75742E70757368286368';
wwv_flow_imp.g_varchar2_table(19) := '293B207D0D0A2020202020202020202020207D293B0D0A20202020202020202020202072657475726E206F75743B0D0A20202020202020207D0D0A0D0A202020202020202066756E6374696F6E2072656E6465722829207B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(20) := '2020626F7865732E666F72456163682866756E6374696F6E2028626F782C206929207B0D0A20202020202020202020202020202020766172206368203D2063686172735B695D3B0D0A20202020202020202020202020202020626F782E76616C7565203D';
wwv_flow_imp.g_varchar2_table(21) := '206368203D3D3D20756E646566696E6564203F202222203A20286366672E6D61736B203F2042554C4C4554203A206368293B0D0A20202020202020202020202020202020626F782E636C6173734C6973742E746F67676C65282269732D66696C6C656422';
wwv_flow_imp.g_varchar2_table(22) := '2C20636820213D3D20756E646566696E6564293B0D0A2020202020202020202020207D293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F205772697465207468652068696464656E20696E70757420616E642066697265206576656E74';
wwv_flow_imp.g_varchar2_table(23) := '730D0A202020202020202066756E6374696F6E2073796E6328757365722C2073696C656E7429207B0D0A2020202020202020202020207661722076203D2063686172732E6A6F696E282222293B0D0A202020202020202020202020766172206368616E67';
wwv_flow_imp.g_varchar2_table(24) := '6564203D207620213D3D2068696464656E2E76616C75653B0D0A20202020202020202020202068696464656E2E76616C7565203D20763B0D0A20202020202020202020202069662028762E6C656E677468203C206C656E29207B207375626D6974746564';
wwv_flow_imp.g_varchar2_table(25) := '203D2066616C73653B207D0D0A20202020202020202020202069662028216368616E676564207C7C2073696C656E7429207B2072657475726E3B207D0D0A202020202020202020202020617065782E6576656E742E747269676765722868696464656E2C';
wwv_flow_imp.g_varchar2_table(26) := '20226368616E676522293B0D0A202020202020202020202020617065782E6576656E742E747269676765722868696464656E2C20226F74702D6368616E6765222C207B2076616C75653A2076207D293B0D0A202020202020202020202020696620287573';
wwv_flow_imp.g_varchar2_table(27) := '657220262620762E6C656E677468203D3D3D206C656E29207B0D0A20202020202020202020202020202020617065782E6576656E742E747269676765722868696464656E2C20226F74702D636F6D706C657465222C207B2076616C75653A2076207D293B';
wwv_flow_imp.g_varchar2_table(28) := '0D0A20202020202020202020202020202020696620286366672E6175746F5375626D6974203D3D3D20227375626D69742220262620217375626D697474656429207B0D0A20202020202020202020202020202020202020207375626D6974746564203D20';
wwv_flow_imp.g_varchar2_table(29) := '747275653B0D0A2020202020202020202020202020202020202020617065782E706167652E7375626D697428293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A20202020202020207D0D0A0D0A2020202020';
wwv_flow_imp.g_varchar2_table(30) := '20202066756E6374696F6E20666F637573426F78286929207B0D0A20202020202020202020202076617220626F78203D20626F7865735B4D6174682E6D617828302C204D6174682E6D696E28692C206C656E202D203129295D3B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(31) := '2020202069662028626F7829207B20626F782E666F63757328293B207D0D0A20202020202020207D0D0A0D0A202020202020202066756E6374696F6E2066696C6C2873746172742C2061727229207B0D0A202020202020202020202020766172206E203D';
wwv_flow_imp.g_varchar2_table(32) := '20303B0D0A202020202020202020202020666F722028766172206B203D20303B206B203C206172722E6C656E677468202626207374617274202B206B203C206C656E3B206B2B2B29207B0D0A2020202020202020202020202020202063686172735B7374';
wwv_flow_imp.g_varchar2_table(33) := '617274202B206B5D203D206172725B6B5D3B0D0A202020202020202020202020202020206E2B2B3B0D0A2020202020202020202020207D0D0A20202020202020202020202072656E64657228293B0D0A20202020202020202020202073796E6328747275';
wwv_flow_imp.g_varchar2_table(34) := '652C2066616C7365293B0D0A202020202020202020202020666F637573426F78287374617274202B206E293B0D0A20202020202020207D0D0A0D0A202020202020202066756E6374696F6E2072656D6F76654174286929207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(35) := '2020206966202869203E3D20302026262069203C2063686172732E6C656E67746829207B2063686172732E73706C69636528692C2031293B207D0D0A20202020202020202020202072656E64657228293B0D0A20202020202020202020202073796E6328';
wwv_flow_imp.g_varchar2_table(36) := '747275652C2066616C7365293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F202D2D2D2D206275696C642074686520626F786573202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(37) := '2D2D2D2D2D2D2D2D0D0A2020202020202020726F6F742E74657874436F6E74656E74203D2022223B0D0A2020202020202020726F6F742E7365744174747269627574652822646972222C20226C747222293B2020202F2F20636F6465732072656164206C';
wwv_flow_imp.g_varchar2_table(38) := '65667420746F2072696768742C20616C736F206F6E2052544C2070616765730D0A2020202020202020726F6F742E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F7470222C0D0A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(39) := '202020202022636F6D2D63656D736D2D6F74702D2D22202B206366672E73697A652C0D0A20202020202020202020202020202020202020202020202020202022636F6D2D63656D736D2D6F74702D2D22202B206366672E7374796C65293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(40) := '20202020696620286366672E6D61736B29207B20726F6F742E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F74702D2D6D61736B656422293B207D0D0A0D0A202020202020202066756E6374696F6E206D616B65426F78286929207B0D';
wwv_flow_imp.g_varchar2_table(41) := '0A20202020202020202020202076617220626F78203D20646F63756D656E742E637265617465456C656D656E742822696E70757422293B0D0A202020202020202020202020626F782E74797065203D202274657874223B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(42) := '20626F782E6964203D206974656D4E616D65202B20225F22202B20693B0D0A202020202020202020202020626F782E636C6173734E616D65203D2022636F6D2D63656D736D2D6F74705F5F626F78223B0D0A202020202020202020202020626F782E7365';
wwv_flow_imp.g_varchar2_table(43) := '744174747269627574652822696E7075746D6F6465222C2069734E756D65726963203F20226E756D6572696322203A20227465787422293B0D0A2020202020202020202020206966202869734E756D6572696329207B20626F782E736574417474726962';
wwv_flow_imp.g_varchar2_table(44) := '75746528227061747465726E222C20225B302D395D2A22293B207D0D0A202020202020202020202020626F782E73657441747472696275746528226175746F636F6D706C657465222C2069203D3D3D2030203F20226F6E652D74696D652D636F64652220';
wwv_flow_imp.g_varchar2_table(45) := '3A20226F666622293B0D0A202020202020202020202020626F782E73657441747472696275746528226175746F6361706974616C697A65222C20226F666622293B0D0A202020202020202020202020626F782E7365744174747269627574652822617574';
wwv_flow_imp.g_varchar2_table(46) := '6F636F7272656374222C20226F666622293B0D0A202020202020202020202020626F782E73657441747472696275746528227370656C6C636865636B222C202266616C736522293B0D0A202020202020202020202020626F782E73657441747472696275';
wwv_flow_imp.g_varchar2_table(47) := '74652822617269612D6C6162656C222C202869734E756D65726963203F202244696769742022203A2022436861726163746572202229202B202869202B203129202B2022206F662022202B206C656E293B0D0A2020202020202020202020206966202863';
wwv_flow_imp.g_varchar2_table(48) := '66672E736570617261746F724166746572203E2030202626206366672E736570617261746F724166746572203C206C656E2026260D0A202020202020202020202020202020202869202B2031292025206366672E736570617261746F724166746572203D';
wwv_flow_imp.g_varchar2_table(49) := '3D3D20302026262069203C206C656E202D203129207B0D0A20202020202020202020202020202020626F782E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F74705F5F626F782D2D67617022293B0D0A2020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(50) := '0D0A0D0A2020202020202020202020202F2F204F6E6C792074686520666972737420656D70747920626F782063616E20626520757365642C20736F2074686520636F6465206E657665722068617320676170730D0A202020202020202020202020626F78';
wwv_flow_imp.g_varchar2_table(51) := '2E6164644576656E744C697374656E65722822666F637573222C2066756E6374696F6E202829207B0D0A202020202020202020202020202020206966202869203E2063686172732E6C656E67746829207B20666F637573426F782863686172732E6C656E';
wwv_flow_imp.g_varchar2_table(52) := '677468293B2072657475726E3B207D0D0A20202020202020202020202020202020626F782E73656C65637428293B0D0A2020202020202020202020207D293B0D0A202020202020202020202020626F782E6164644576656E744C697374656E6572282263';
wwv_flow_imp.g_varchar2_table(53) := '6C69636B222C2066756E6374696F6E202829207B20626F782E73656C65637428293B207D293B0D0A0D0A202020202020202020202020626F782E6164644576656E744C697374656E65722822696E707574222C2066756E6374696F6E20286529207B0D0A';
wwv_flow_imp.g_varchar2_table(54) := '2020202020202020202020202020202076617220726177203D20626F782E76616C75652E73706C69742842554C4C4554292E6A6F696E282222293B0D0A2020202020202020202020202020202069662028626F782E76616C7565203D3D3D20222229207B';
wwv_flow_imp.g_varchar2_table(55) := '2072656D6F766541742869293B2072657475726E3B207D2020202020202F2F20637574202F2073656C656374202B2064656C6574650D0A20202020202020202020202020202020766172207479706564203D20636C65616E28726177293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(56) := '202020202020202020202020696620282174797065642E6C656E67746829207B2072656E64657228293B2072657475726E3B207D2020202020202020202020202F2F2072656A6563746564206368617261637465720D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(57) := '2020202F2F20636172657420706C6163656420696E7369646520612066696C6C656420626F783A206B656570206F6E6C7920746865206E6577206368617261637465720D0A2020202020202020202020202020202069662028652E696E70757454797065';
wwv_flow_imp.g_varchar2_table(58) := '203D3D3D2022696E7365727454657874222026262063686172735B695D20213D3D20756E646566696E65642026262074797065642E6C656E677468203E203129207B0D0A2020202020202020202020202020202020202020766172206F6C64203D207479';
wwv_flow_imp.g_varchar2_table(59) := '7065642E696E6465784F662863686172735B695D293B0D0A2020202020202020202020202020202020202020696620286F6C64203E202D3129207B2074797065642E73706C696365286F6C642C2031293B207D0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(60) := '20202020207479706564203D205B74797065645B74797065642E6C656E677468202D20315D5D3B0D0A202020202020202020202020202020207D0D0A2020202020202020202020202020202066696C6C28692C207479706564293B2020202F2F206F6E65';
wwv_flow_imp.g_varchar2_table(61) := '206368617261637465722C206F7220612077686F6C6520636F64652066726F6D20534D53206175746F66696C6C0D0A2020202020202020202020207D293B0D0A0D0A202020202020202020202020626F782E6164644576656E744C697374656E65722822';
wwv_flow_imp.g_varchar2_table(62) := '6B6579646F776E222C2066756E6374696F6E20286529207B0D0A202020202020202020202020202020207377697463682028652E6B657929207B0D0A202020202020202020202020202020206361736520224261636B7370616365223A0D0A2020202020';
wwv_flow_imp.g_varchar2_table(63) := '202020202020202020202020202020652E70726576656E7444656661756C7428293B0D0A20202020202020202020202020202020202020206966202869203C2063686172732E6C656E67746829207B2072656D6F766541742869293B20666F637573426F';
wwv_flow_imp.g_varchar2_table(64) := '782869293B207D0D0A2020202020202020202020202020202020202020656C7365206966202869203E203029202020202020207B2072656D6F766541742869202D2031293B20666F637573426F782869202D2031293B207D0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(65) := '20202020202020202020627265616B3B0D0A2020202020202020202020202020202063617365202244656C657465223A0D0A2020202020202020202020202020202020202020652E70726576656E7444656661756C7428293B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(66) := '20202020202020202020206966202869203C2063686172732E6C656E67746829207B2072656D6F766541742869293B20666F637573426F782869293B207D0D0A2020202020202020202020202020202020202020627265616B3B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(67) := '20202020202020206361736520224172726F774C656674223A2020652E70726576656E7444656661756C7428293B20666F637573426F782869202D2031293B20627265616B3B0D0A202020202020202020202020202020206361736520224172726F7752';
wwv_flow_imp.g_varchar2_table(68) := '69676874223A20652E70726576656E7444656661756C7428293B20666F637573426F782869202B2031293B20627265616B3B0D0A20202020202020202020202020202020636173652022486F6D65223A20202020202020652E70726576656E7444656661';
wwv_flow_imp.g_varchar2_table(69) := '756C7428293B20666F637573426F782830293B20627265616B3B0D0A20202020202020202020202020202020636173652022456E64223A2020202020202020652E70726576656E7444656661756C7428293B20666F637573426F782863686172732E6C65';
wwv_flow_imp.g_varchar2_table(70) := '6E677468293B20627265616B3B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A0D0A202020202020202020202020626F782E6164644576656E744C697374656E657228227061737465222C2066756E6374';
wwv_flow_imp.g_varchar2_table(71) := '696F6E20286529207B0D0A20202020202020202020202020202020652E70726576656E7444656661756C7428293B0D0A2020202020202020202020202020202069662028216366672E616C6C6F77506173746529207B2072657475726E3B207D0D0A2020';
wwv_flow_imp.g_varchar2_table(72) := '20202020202020202020202020207661722064617461203D20652E636C6970626F61726444617461207C7C2077696E646F772E636C6970626F617264446174613B0D0A2020202020202020202020202020202076617220617272203D20636C65616E2864';
wwv_flow_imp.g_varchar2_table(73) := '617461203F20646174612E676574446174612822746578742229203A202222293B0D0A20202020202020202020202020202020696620286172722E6C656E67746829207B2066696C6C286172722E6C656E677468203E3D206C656E203F2030203A20692C';
wwv_flow_imp.g_varchar2_table(74) := '20617272293B207D0D0A2020202020202020202020207D293B0D0A0D0A20202020202020202020202072657475726E20626F783B0D0A20202020202020207D0D0A0D0A2020202020202020666F7220287661722069203D20303B2069203C206C656E3B20';
wwv_flow_imp.g_varchar2_table(75) := '692B2B29207B0D0A2020202020202020202020207661722062203D206D616B65426F782869293B0D0A202020202020202020202020626F7865732E707573682862293B0D0A202020202020202020202020726F6F742E617070656E644368696C64286229';
wwv_flow_imp.g_varchar2_table(76) := '3B0D0A20202020202020207D0D0A0D0A202020202020202063686172732020203D20636C65616E2868696464656E2E76616C7565292E736C69636528302C206C656E293B0D0A2020202020202020696E697469616C203D2063686172732E6A6F696E2822';
wwv_flow_imp.g_varchar2_table(77) := '22293B0D0A202020202020202068696464656E2E76616C7565203D20696E697469616C3B0D0A202020202020202072656E64657228293B0D0A0D0A20202020202020202F2F202D2D2D2D20726567697374657220617320616E2041504558206974656D20';
wwv_flow_imp.g_varchar2_table(78) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202020202020617065782E6974656D2E637265617465286974656D4E616D652C207B0D0A2020202020202020202020206974656D5F747970653A';
wwv_flow_imp.g_varchar2_table(79) := '2022434F4D5F43454D534D5F4F54505F494E505554222C0D0A20202020202020202020202067657456616C75653A2066756E6374696F6E202829207B2072657475726E2063686172732E6A6F696E282222293B207D2C0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(80) := '73657456616C75653A2066756E6374696F6E202876616C75652C20646973706C617956616C75652C2073757070726573734368616E676529207B0D0A202020202020202020202020202020206368617273203D20636C65616E2876616C7565292E736C69';
wwv_flow_imp.g_varchar2_table(81) := '636528302C206C656E293B0D0A2020202020202020202020202020202072656E64657228293B0D0A2020202020202020202020202020202073796E632866616C73652C20212173757070726573734368616E6765293B0D0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(82) := '7D2C0D0A202020202020202020202020646973706C617956616C7565466F723A2066756E6374696F6E202876616C756529207B2072657475726E2076616C75653B207D2C0D0A20202020202020202020202064697361626C653A2066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(83) := '2829207B0D0A20202020202020202020202020202020626F7865732E666F72456163682866756E6374696F6E20286229207B20622E64697361626C6564203D20747275653B207D293B0D0A2020202020202020202020202020202068696464656E2E6469';
wwv_flow_imp.g_varchar2_table(84) := '7361626C6564203D20747275653B0D0A20202020202020202020202020202020726F6F742E636C6173734C6973742E616464282269732D64697361626C656422293B0D0A2020202020202020202020207D2C0D0A202020202020202020202020656E6162';
wwv_flow_imp.g_varchar2_table(85) := '6C653A2066756E6374696F6E202829207B0D0A20202020202020202020202020202020626F7865732E666F72456163682866756E6374696F6E20286229207B20622E64697361626C6564203D2066616C73653B207D293B0D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(86) := '202020202068696464656E2E64697361626C6564203D2066616C73653B0D0A20202020202020202020202020202020726F6F742E636C6173734C6973742E72656D6F7665282269732D64697361626C656422293B0D0A2020202020202020202020207D2C';
wwv_flow_imp.g_varchar2_table(87) := '0D0A20202020202020202020202069734368616E6765643A2066756E6374696F6E202829207B2072657475726E2063686172732E6A6F696E2822222920213D3D20696E697469616C3B207D2C0D0A202020202020202020202020736574466F637573546F';
wwv_flow_imp.g_varchar2_table(88) := '3A2066756E6374696F6E202829207B0D0A2020202020202020202020202020202076617220626F78203D20626F7865735B4D6174682E6D696E2863686172732E6C656E6774682C206C656E202D2031295D3B0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(89) := '626F782E666F63757328293B0D0A2020202020202020202020202020202072657475726E202428626F78293B0D0A2020202020202020202020207D0D0A20202020202020207D293B0D0A0D0A2020202020202020696620286366672E6175746F466F6375';
wwv_flow_imp.g_varchar2_table(90) := '7329207B2073657454696D656F75742866756E6374696F6E202829207B20666F637573426F782863686172732E6C656E677468293B207D2C2030293B207D0D0A202020207D0D0A0D0A2020202077696E646F772E4F7470496E707574203D207B206D6F75';
wwv_flow_imp.g_varchar2_table(91) := '6E743A206D6F756E74207D3B0D0A7D2928617065782C20617065782E6A5175657279293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(15987466374271083)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_file_name=>'otp-input.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E636F6D2D63656D736D2D6F7470207B2D2D6F74702D626F726465723A0D0A766172280D0A2D2D612D6669656C642D696E7075742D626F726465722D636F6C6F722C0D0A766172282D2D75742D6669656C642D696E7075742D626F726465722D636F6C6F';
wwv_flow_imp.g_varchar2_table(2) := '722C2023386639353965290D0A293B2D2D6F74702D62673A0D0A766172280D0A2D2D612D6669656C642D696E7075742D6261636B67726F756E642D636F6C6F722C0D0A766172282D2D75742D6669656C642D696E7075742D6261636B67726F756E642D63';
wwv_flow_imp.g_varchar2_table(3) := '6F6C6F722C2023666666666666290D0A293B2D2D6F74702D746578743A0D0A766172280D0A2D2D612D6669656C642D696E7075742D746578742D636F6C6F722C0D0A766172282D2D75742D6669656C642D696E7075742D746578742D636F6C6F722C2069';
wwv_flow_imp.g_varchar2_table(4) := '6E6865726974290D0A293B2D2D6F74702D616363656E743A0D0A766172280D0A2D2D612D70616C657474652D7072696D6172792C0D0A766172282D2D75742D70616C657474652D7072696D6172792C2023303537326365290D0A293B2D2D6F74702D6461';
wwv_flow_imp.g_varchar2_table(5) := '6E6765723A0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A293B2D2D6F74702D73697A653A202020322E373572656D3B2D2D6F74702D66';
wwv_flow_imp.g_varchar2_table(6) := '6F6E743A202020312E323572656D3B2D2D6F74702D7261646975733A20302E33373572656D3B2D2D6F74702D6761703A20202020302E3572656D3B646973706C61793A20696E6C696E652D666C65783B666C65782D777261703A206E6F777261703B616C';
wwv_flow_imp.g_varchar2_table(7) := '69676E2D6974656D733A2063656E7465723B6A7573746966792D636F6E74656E743A2063656E7465723B6761703A20766172282D2D6F74702D676170293B6D61782D77696474683A20313030253B7D2E636F6D2D63656D736D2D6F74702D2D736D616C6C';
wwv_flow_imp.g_varchar2_table(8) := '207B2D2D6F74702D73697A653A20322E323572656D3B2D2D6F74702D666F6E743A203172656D3B7D2E636F6D2D63656D736D2D6F74702D2D6D656469756D207B2D2D6F74702D73697A653A20322E373572656D3B2D2D6F74702D666F6E743A20312E3235';
wwv_flow_imp.g_varchar2_table(9) := '72656D3B7D2E636F6D2D63656D736D2D6F74702D2D6C61726765207B2D2D6F74702D73697A653A20332E3572656D3B2D2D6F74702D666F6E743A20312E36323572656D3B7D2E636F6D2D63656D736D2D6F74705F5F626F78207B626F782D73697A696E67';
wwv_flow_imp.g_varchar2_table(10) := '3A20626F726465722D626F783B77696474683A20766172282D2D6F74702D73697A65293B6865696768743A20766172282D2D6F74702D73697A65293B6D696E2D77696474683A20303B70616464696E673A203020302034707820303B666C65783A203020';
wwv_flow_imp.g_varchar2_table(11) := '31206175746F3B746578742D616C69676E3A2063656E7465723B666F6E742D73697A653A20766172282D2D6F74702D666F6E74293B666F6E742D7765696768743A203630303B6C696E652D6865696768743A206E6F726D616C3B636F6C6F723A20766172';
wwv_flow_imp.g_varchar2_table(12) := '282D2D6F74702D74657874293B6261636B67726F756E643A20766172282D2D6F74702D6267293B626F726465723A2031707820736F6C696420766172282D2D6F74702D626F72646572293B626F726465722D7261646975733A20766172282D2D6F74702D';
wwv_flow_imp.g_varchar2_table(13) := '726164697573293B63617265742D636F6C6F723A20766172282D2D6F74702D616363656E74293B7472616E73666F726D3A0D0A7472616E736C617465592830290D0A7363616C652831293B7472616E73666F726D2D6F726967696E3A2063656E7465723B';
wwv_flow_imp.g_varchar2_table(14) := '7472616E736974696F6E3A0D0A7472616E73666F726D20302E3332732063756269632D62657A69657228302E32322C20312C20302E33362C2031292C0D0A626F782D736861646F7720302E3332732063756269632D62657A69657228302E32322C20312C';
wwv_flow_imp.g_varchar2_table(15) := '20302E33362C2031292C0D0A626F726465722D636F6C6F7220302E32347320656173652C0D0A6261636B67726F756E642D636F6C6F7220302E32347320656173652C0D0A6F70616369747920302E32347320656173653B77696C6C2D6368616E67653A0D';
wwv_flow_imp.g_varchar2_table(16) := '0A7472616E73666F726D2C0D0A626F782D736861646F773B7D2E636F6D2D63656D736D2D6F74705F5F626F782D2D676170207B6D617267696E2D696E6C696E652D656E643A2063616C6328766172282D2D6F74702D67617029202A20312E35293B7D2E63';
wwv_flow_imp.g_varchar2_table(17) := '6F6D2D63656D736D2D6F74705F5F626F783A686F7665723A6E6F74283A666F63757329207B626F726465722D636F6C6F723A0D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172282D2D6F74702D616363656E7429203630252C0D0A7661';
wwv_flow_imp.g_varchar2_table(18) := '72282D2D6F74702D626F72646572290D0A293B7472616E73666F726D3A0D0A7472616E736C61746559282D317078290D0A7363616C6528312E303135293B626F782D736861646F773A0D0A302034707820387078207267626128302C20302C20302C2030';
wwv_flow_imp.g_varchar2_table(19) := '2E3036292C0D0A30203770782031367078207267626128302C20302C20302C20302E3035293B7D406B65796672616D6573206F74702D666F6375732D696E207B3025207B7472616E73666F726D3A0D0A7472616E736C617465592830290D0A7363616C65';
wwv_flow_imp.g_varchar2_table(20) := '2831293B7D353525207B7472616E73666F726D3A0D0A7472616E736C61746559282D367078290D0A7363616C6528312E303735293B7D373825207B7472616E73666F726D3A0D0A7472616E736C61746559282D337078290D0A7363616C6528312E303435';
wwv_flow_imp.g_varchar2_table(21) := '293B7D31303025207B7472616E73666F726D3A0D0A7472616E736C61746559282D347078290D0A7363616C6528312E3036293B7D7D2E636F6D2D63656D736D2D6F74705F5F626F783A666F637573207B6F75746C696E653A206E6F6E653B626F72646572';
wwv_flow_imp.g_varchar2_table(22) := '2D636F6C6F723A20766172282D2D6F74702D616363656E74293B7472616E73666F726D3A0D0A7472616E736C61746559282D347078290D0A7363616C6528312E3036293B626F782D736861646F773A0D0A0D0A3020302030203370780D0A636F6C6F722D';
wwv_flow_imp.g_varchar2_table(23) := '6D6978280D0A696E20737267622C0D0A766172282D2D6F74702D616363656E7429203232252C0D0A7472616E73706172656E740D0A292C0D0A0D0A30203020313270780D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172282D2D6F7470';
wwv_flow_imp.g_varchar2_table(24) := '2D616363656E7429203234252C0D0A7472616E73706172656E740D0A292C0D0A0D0A30203020323870780D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172282D2D6F74702D616363656E7429203136252C0D0A7472616E73706172656E';
wwv_flow_imp.g_varchar2_table(25) := '740D0A292C0D0A0D0A30203134707820323870780D0A7267626128302C20302C20302C20302E3137292C0D0A0D0A302036707820313270780D0A7267626128302C20302C20302C20302E3131293B616E696D6174696F6E3A0D0A6F74702D666F6375732D';
wwv_flow_imp.g_varchar2_table(26) := '696E0D0A302E3432730D0A63756269632D62657A69657228302E32322C20312C20302E33362C2031293B7D2E636F6D2D63656D736D2D6F74703A666F6375732D77697468696E0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A6E6F74283A666F63';
wwv_flow_imp.g_varchar2_table(27) := '757329207B6F7061636974793A20302E38383B7472616E73666F726D3A0D0A7472616E736C617465592830290D0A7363616C6528302E393835293B7D2E636F6D2D63656D736D2D6F74705F5F626F782E69732D66696C6C6564207B626F726465722D636F';
wwv_flow_imp.g_varchar2_table(28) := '6C6F723A0D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172282D2D6F74702D616363656E7429203735252C0D0A766172282D2D6F74702D626F72646572290D0A293B7D2E636F6D2D63656D736D2D6F74702D2D726F756E646564202E63';
wwv_flow_imp.g_varchar2_table(29) := '6F6D2D63656D736D2D6F74705F5F626F78207B2D2D6F74702D7261646975733A2039393970783B7D2E636F6D2D63656D736D2D6F74702D2D756E6465726C696E65202E636F6D2D63656D736D2D6F74705F5F626F78207B6261636B67726F756E643A2074';
wwv_flow_imp.g_varchar2_table(30) := '72616E73706172656E743B626F726465722D77696474683A203020302032707820303B626F726465722D7261646975733A20303B7D2E636F6D2D63656D736D2D6F74702D2D756E6465726C696E65202E636F6D2D63656D736D2D6F74705F5F626F783A66';
wwv_flow_imp.g_varchar2_table(31) := '6F637573207B626F782D736861646F773A0D0A30203570782031307078207267626128302C20302C20302C20302E3036293B7D2E636F6D2D63656D736D2D6F74702D77726170706572207B2D2D6F74702D636F6E7461696E65722D62673A202366316632';
wwv_flow_imp.g_varchar2_table(32) := '66343B706F736974696F6E3A2072656C61746976653B646973706C61793A20696E6C696E652D666C65783B666C65782D646972656374696F6E3A20636F6C756D6E3B6D696E2D77696474683A20323272656D3B6D61782D77696474683A20313030253B70';
wwv_flow_imp.g_varchar2_table(33) := '616464696E673A20303B6D617267696E2D746F703A20302E3572656D3B6261636B67726F756E643A20766172282D2D6F74702D636F6E7461696E65722D6267293B626F726465723A0D0A31707820736F6C69640D0A766172280D0A2D2D612D6669656C64';
wwv_flow_imp.g_varchar2_table(34) := '2D696E7075742D626F726465722D636F6C6F722C0D0A766172282D2D75742D6669656C642D696E7075742D626F726465722D636F6C6F722C2023386639353965290D0A293B626F726465722D7261646975733A20302E373572656D3B6F766572666C6F77';
wwv_flow_imp.g_varchar2_table(35) := '3A2068696464656E3B7D2E636F6D2D63656D736D2D6F74702D686561646572207B706F736974696F6E3A2072656C61746976653B69736F6C6174696F6E3A2069736F6C6174653B6F766572666C6F773A2068696464656E3B77696474683A20313030253B';
wwv_flow_imp.g_varchar2_table(36) := '6D696E2D6865696768743A203772656D3B646973706C61793A20666C65783B616C69676E2D6974656D733A2063656E7465723B6A7573746966792D636F6E74656E743A2063656E7465723B6261636B67726F756E643A0D0A636F6C6F722D6D6978280D0A';
wwv_flow_imp.g_varchar2_table(37) := '696E20737267622C0D0A766172280D0A2D2D612D70616C657474652D7072696D6172792C0D0A766172282D2D75742D70616C657474652D7072696D6172792C2023303537326365290D0A29203132252C0D0A766172282D2D6F74702D636F6E7461696E65';
wwv_flow_imp.g_varchar2_table(38) := '722D6267290D0A293B7D2E636F6D2D63656D736D2D6F74702D6865616465723A3A6265666F7265207B636F6E74656E743A0D0A22E280A220203720202A2020E280A22020332020E280A220202A2020392020E280A220203120202A2020E280A220203620';
wwv_flow_imp.g_varchar2_table(39) := '20E280A220202A2020342020E280A22020220D0A22E280A220203220202A2020E280A22020382020E280A220202A2020352020E280A220203020202A2020E280A22020372020E280A220202A2020332020E280A2223B706F736974696F6E3A206162736F';
wwv_flow_imp.g_varchar2_table(40) := '6C7574653B746F703A203530253B6C6566743A202D3130253B77696474683A20313230253B7472616E73666F726D3A0D0A7472616E736C617465282D32252C202D353025293B666F6E742D73697A653A20312E313572656D3B666F6E742D776569676874';
wwv_flow_imp.g_varchar2_table(41) := '3A203630303B6C696E652D6865696768743A20322E353B6C65747465722D73706163696E673A20302E3872656D3B77686974652D73706163653A206E6F726D616C3B636F6C6F723A0D0A766172280D0A2D2D612D70616C657474652D7072696D6172792C';
wwv_flow_imp.g_varchar2_table(42) := '0D0A766172282D2D75742D70616C657474652D7072696D6172792C2023303537326365290D0A293B6F7061636974793A20302E30373B706F696E7465722D6576656E74733A206E6F6E653B757365722D73656C6563743A206E6F6E653B616E696D617469';
wwv_flow_imp.g_varchar2_table(43) := '6F6E3A0D0A6F74702D7061747465726E2D6D6F76650D0A3138730D0A6C696E6561720D0A696E66696E6974653B7A2D696E6465783A202D313B7D406B65796672616D6573206F74702D7061747465726E2D6D6F7665207B66726F6D207B7472616E73666F';
wwv_flow_imp.g_varchar2_table(44) := '726D3A0D0A7472616E736C617465282D32252C202D353025293B7D746F207B7472616E73666F726D3A0D0A7472616E736C6174652836252C202D353025293B7D7D2E636F6D2D63656D736D2D6F74702D6865616465725F5F69636F6E207B706F73697469';
wwv_flow_imp.g_varchar2_table(45) := '6F6E3A2072656C61746976653B7A2D696E6465783A20323B77696474683A20342E3572656D3B6865696768743A20342E3572656D3B646973706C61793A20696E6C696E652D666C65782021696D706F7274616E743B616C69676E2D6974656D733A206365';
wwv_flow_imp.g_varchar2_table(46) := '6E7465722021696D706F7274616E743B6A7573746966792D636F6E74656E743A2063656E7465722021696D706F7274616E743B626F782D73697A696E673A20626F726465722D626F783B70616464696E673A20303B6D617267696E3A20303B666F6E742D';
wwv_flow_imp.g_varchar2_table(47) := '73697A653A20322E333572656D3B6C696E652D6865696768743A20312021696D706F7274616E743B636F6C6F723A0D0A766172280D0A2D2D612D70616C657474652D7072696D6172792C0D0A766172282D2D75742D70616C657474652D7072696D617279';
wwv_flow_imp.g_varchar2_table(48) := '2C2023303537326365290D0A293B6261636B67726F756E643A0D0A72676261283235352C203235352C203235352C20302E3535293B626F726465723A0D0A31707820736F6C69640D0A72676261283235352C203235352C203235352C20302E37293B626F';
wwv_flow_imp.g_varchar2_table(49) := '726465722D7261646975733A203530253B626F782D736861646F773A0D0A302036707820313870780D0A7267626128302C20302C20302C20302E3036293B6261636B64726F702D66696C7465723A0D0A626C757228347078293B2D7765626B69742D6261';
wwv_flow_imp.g_varchar2_table(50) := '636B64726F702D66696C7465723A0D0A626C757228347078293B7D2E636F6D2D63656D736D2D6F74702D6865616465725F5F69636F6E3A3A6265666F7265207B646973706C61793A20626C6F636B3B6D617267696E3A20303B70616464696E673A20303B';
wwv_flow_imp.g_varchar2_table(51) := '6C696E652D6865696768743A20312021696D706F7274616E743B7472616E73666F726D3A0D0A7472616E736C61746559282D317078293B7D2E636F6D2D63656D736D2D6F74702D626F6479207B646973706C61793A20666C65783B666C65782D64697265';
wwv_flow_imp.g_varchar2_table(52) := '6374696F6E3A20636F6C756D6E3B616C69676E2D6974656D733A2063656E7465723B77696474683A20313030253B626F782D73697A696E673A20626F726465722D626F783B70616464696E673A0D0A312E3472656D0D0A312E3572656D0D0A312E357265';
wwv_flow_imp.g_varchar2_table(53) := '6D3B6261636B67726F756E643A0D0A766172282D2D6F74702D636F6E7461696E65722D6267293B7D2E636F6D2D63656D736D2D6F74702D7469746C65207B6D617267696E2D626F74746F6D3A203172656D3B666F6E742D73697A653A20302E393572656D';
wwv_flow_imp.g_varchar2_table(54) := '3B666F6E742D7765696768743A203630303B6C696E652D6865696768743A20312E333B636F6C6F723A0D0A766172280D0A2D2D612D6669656C642D696E7075742D746578742D636F6C6F722C0D0A766172282D2D75742D6669656C642D696E7075742D74';
wwv_flow_imp.g_varchar2_table(55) := '6578742D636F6C6F722C20696E6865726974290D0A293B746578742D616C69676E3A2063656E7465723B6C65747465722D73706163696E673A20302E3032656D3B7D2E617065782D706167652D6974656D2D6572726F720D0A2B202E636F6D2D63656D73';
wwv_flow_imp.g_varchar2_table(56) := '6D2D6F74702D777261707065720D0A2E636F6D2D63656D736D2D6F74705F5F626F78207B626F726465722D636F6C6F723A0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C657474652D64616E6765';
wwv_flow_imp.g_varchar2_table(57) := '722C2023643933303235290D0A293B7D2E617065782D706167652D6974656D2D6572726F720D0A2B202E636F6D2D63656D736D2D6F74702D777261707065720D0A2E636F6D2D63656D736D2D6F74705F5F626F783A666F637573207B626F726465722D63';
wwv_flow_imp.g_varchar2_table(58) := '6F6C6F723A0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A293B626F782D736861646F773A0D0A0D0A3020302030203370780D0A636F6C';
wwv_flow_imp.g_varchar2_table(59) := '6F722D6D6978280D0A696E20737267622C0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C657474652D64616E6765722C2023643933303235290D0A29203232252C0D0A7472616E73706172656E74';
wwv_flow_imp.g_varchar2_table(60) := '0D0A292C0D0A0D0A30203020313470780D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C657474652D64616E6765722C202364393330323529';
wwv_flow_imp.g_varchar2_table(61) := '0D0A29203232252C0D0A7472616E73706172656E740D0A292C0D0A0D0A30203020323870780D0A636F6C6F722D6D6978280D0A696E20737267622C0D0A766172280D0A2D2D612D70616C657474652D64616E6765722C0D0A766172282D2D75742D70616C';
wwv_flow_imp.g_varchar2_table(62) := '657474652D64616E6765722C2023643933303235290D0A29203134252C0D0A7472616E73706172656E740D0A292C0D0A0D0A30203134707820323870780D0A7267626128302C20302C20302C20302E3137292C0D0A0D0A302036707820313270780D0A72';
wwv_flow_imp.g_varchar2_table(63) := '67626128302C20302C20302C20302E3131293B7D2E636F6D2D63656D736D2D6F74702E69732D64697361626C6564207B6F7061636974793A20302E363B7D2E636F6D2D63656D736D2D6F74702E69732D64697361626C65640D0A2E636F6D2D63656D736D';
wwv_flow_imp.g_varchar2_table(64) := '2D6F74705F5F626F78207B637572736F723A206E6F742D616C6C6F7765643B7472616E73666F726D3A206E6F6E653B626F782D736861646F773A206E6F6E653B7D406D6564696120286D61782D77696474683A20343830707829207B2E636F6D2D63656D';
wwv_flow_imp.g_varchar2_table(65) := '736D2D6F74702D77726170706572207B6D696E2D77696474683A20303B77696474683A20313030253B7D2E636F6D2D63656D736D2D6F74702D626F6479207B70616464696E673A0D0A312E323572656D0D0A302E373572656D0D0A312E333572656D3B7D';
wwv_flow_imp.g_varchar2_table(66) := '2E636F6D2D63656D736D2D6F74702D2D6C61726765207B2D2D6F74702D73697A653A20322E373572656D3B2D2D6F74702D666F6E743A20312E323572656D3B7D2E636F6D2D63656D736D2D6F7470207B2D2D6F74702D6761703A20302E33373572656D3B';
wwv_flow_imp.g_varchar2_table(67) := '7D7D406D656469612028707265666572732D726564756365642D6D6F74696F6E3A2072656475636529207B2E636F6D2D63656D736D2D6F74705F5F626F782C0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A686F7665722C0D0A2E636F6D2D6365';
wwv_flow_imp.g_varchar2_table(68) := '6D736D2D6F74705F5F626F783A666F6375732C0D0A2E636F6D2D63656D736D2D6F74703A666F6375732D77697468696E0D0A2E636F6D2D63656D736D2D6F74705F5F626F783A6E6F74283A666F63757329207B616E696D6174696F6E3A206E6F6E653B74';
wwv_flow_imp.g_varchar2_table(69) := '72616E736974696F6E3A206E6F6E653B7472616E73666F726D3A206E6F6E653B7D2E636F6D2D63656D736D2D6F74702D6865616465723A3A6265666F7265207B616E696D6174696F6E3A206E6F6E653B7D7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(15986196219266457)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_file_name=>'otp-input.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2166756E6374696F6E28652C74297B2275736520737472696374223B766172206E3D7B6E756D657269633A2F5B302D395D2F2C616C7068616E756D657269633A2F5B412D5A612D7A302D395D2F2C616E793A2F5C532F7D3B77696E646F772E4F7470496E';
wwv_flow_imp.g_varchar2_table(2) := '7075743D7B6D6F756E743A66756E6374696F6E28612C69297B76617220723D646F63756D656E742E676574456C656D656E74427949642861292C6F3D646F63756D656E742E676574456C656D656E744279496428612B225F4F545022293B696628722626';
wwv_flow_imp.g_varchar2_table(3) := '6F297B76617220632C753D692E6C656E6774682C733D6E5B692E696E707574547970655D7C7C6E2E6E756D657269632C6C3D226E756D65726963223D3D3D692E696E707574547970652C663D5B5D2C643D5B5D2C703D21313B6F2E74657874436F6E7465';
wwv_flow_imp.g_varchar2_table(4) := '6E743D22222C6F2E7365744174747269627574652822646972222C226C747222292C6F2E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F7470222C22636F6D2D63656D736D2D6F74702D2D222B692E73697A652C22636F6D2D63656D73';
wwv_flow_imp.g_varchar2_table(5) := '6D2D6F74702D2D222B692E7374796C65292C692E6D61736B26266F2E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F74702D2D6D61736B656422293B666F7228766172206D3D303B6D3C753B6D2B2B297B76617220763D6B286D293B64';
wwv_flow_imp.g_varchar2_table(6) := '2E707573682876292C6F2E617070656E644368696C642876297D663D6728722E76616C7565292E736C69636528302C75292C633D662E6A6F696E282222292C722E76616C75653D632C6828292C652E6974656D2E63726561746528612C7B6974656D5F74';
wwv_flow_imp.g_varchar2_table(7) := '7970653A22434F4D5F43454D534D5F4F54505F494E505554222C67657456616C75653A66756E6374696F6E28297B72657475726E20662E6A6F696E282222297D2C73657456616C75653A66756E6374696F6E28652C742C6E297B663D672865292E736C69';
wwv_flow_imp.g_varchar2_table(8) := '636528302C75292C6828292C622821312C21216E297D2C646973706C617956616C7565466F723A66756E6374696F6E2865297B72657475726E20657D2C64697361626C653A66756E6374696F6E28297B642E666F72456163682866756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(9) := '297B652E64697361626C65643D21307D292C722E64697361626C65643D21302C6F2E636C6173734C6973742E616464282269732D64697361626C656422297D2C656E61626C653A66756E6374696F6E28297B642E666F72456163682866756E6374696F6E';
wwv_flow_imp.g_varchar2_table(10) := '2865297B652E64697361626C65643D21317D292C722E64697361626C65643D21312C6F2E636C6173734C6973742E72656D6F7665282269732D64697361626C656422297D2C69734368616E6765643A66756E6374696F6E28297B72657475726E20662E6A';
wwv_flow_imp.g_varchar2_table(11) := '6F696E28222229213D3D637D2C736574466F637573546F3A66756E6374696F6E28297B76617220653D645B4D6174682E6D696E28662E6C656E6774682C752D31295D3B72657475726E20652E666F63757328292C742865297D7D292C692E6175746F466F';
wwv_flow_imp.g_varchar2_table(12) := '637573262673657454696D656F75742866756E6374696F6E28297B7928662E6C656E677468297D2C30297D66756E6374696F6E20672865297B76617220743D5B5D3B72657475726E2041727261792E66726F6D28537472696E67286E756C6C3D3D653F22';
wwv_flow_imp.g_varchar2_table(13) := '223A6529292E666F72456163682866756E6374696F6E2865297B22616E7922213D3D692E696E70757454797065262628653D66756E6374696F6E2865297B76617220743D652E63686172436F646541742830293B72657475726E20743E3D313737362626';
wwv_flow_imp.g_varchar2_table(14) := '743C3D313738353F537472696E672E66726F6D43686172436F646528742D313737362B3438293A743E3D313633322626743C3D313634313F537472696E672E66726F6D43686172436F646528742D313633322B3438293A657D286529292C732E74657374';
wwv_flow_imp.g_varchar2_table(15) := '2865292626742E707573682865297D292C747D66756E6374696F6E206828297B642E666F72456163682866756E6374696F6E28652C74297B766172206E3D665B745D3B652E76616C75653D766F696420303D3D3D6E3F22223A692E6D61736B3F22E280A2';
wwv_flow_imp.g_varchar2_table(16) := '223A6E2C652E636C6173734C6973742E746F67676C65282269732D66696C6C6564222C766F69642030213D3D6E297D297D66756E6374696F6E206228742C6E297B76617220613D662E6A6F696E282222292C6F3D61213D3D722E76616C75653B722E7661';
wwv_flow_imp.g_varchar2_table(17) := '6C75653D612C612E6C656E6774683C75262628703D2131292C6F2626216E262628652E6576656E742E7472696767657228722C226368616E676522292C652E6576656E742E7472696767657228722C226F74702D6368616E6765222C7B76616C75653A61';
wwv_flow_imp.g_varchar2_table(18) := '7D292C742626612E6C656E6774683D3D3D75262628652E6576656E742E7472696767657228722C226F74702D636F6D706C657465222C7B76616C75653A617D292C227375626D697422213D3D692E6175746F5375626D69747C7C707C7C28703D21302C65';
wwv_flow_imp.g_varchar2_table(19) := '2E706167652E7375626D697428292929297D66756E6374696F6E20792865297B76617220743D645B4D6174682E6D617828302C4D6174682E6D696E28652C752D3129295D3B742626742E666F63757328297D66756E6374696F6E204128652C74297B666F';
wwv_flow_imp.g_varchar2_table(20) := '7228766172206E3D302C613D303B613C742E6C656E6774682626652B613C753B612B2B29665B652B615D3D745B615D2C6E2B2B3B6828292C622821302C2131292C7928652B6E297D66756E6374696F6E20452865297B653E3D302626653C662E6C656E67';
wwv_flow_imp.g_varchar2_table(21) := '74682626662E73706C69636528652C31292C6828292C622821302C2131297D66756E6374696F6E206B2865297B76617220743D646F63756D656E742E637265617465456C656D656E742822696E70757422293B72657475726E20742E747970653D227465';
wwv_flow_imp.g_varchar2_table(22) := '7874222C742E69643D612B225F222B652C742E636C6173734E616D653D22636F6D2D63656D736D2D6F74705F5F626F78222C742E7365744174747269627574652822696E7075746D6F6465222C6C3F226E756D65726963223A227465787422292C6C2626';
wwv_flow_imp.g_varchar2_table(23) := '742E73657441747472696275746528227061747465726E222C225B302D395D2A22292C742E73657441747472696275746528226175746F636F6D706C657465222C303D3D3D653F226F6E652D74696D652D636F6465223A226F666622292C742E73657441';
wwv_flow_imp.g_varchar2_table(24) := '747472696275746528226175746F6361706974616C697A65222C226F666622292C742E73657441747472696275746528226175746F636F7272656374222C226F666622292C742E73657441747472696275746528227370656C6C636865636B222C226661';
wwv_flow_imp.g_varchar2_table(25) := '6C736522292C742E7365744174747269627574652822617269612D6C6162656C222C286C3F22446967697420223A224368617261637465722022292B28652B31292B22206F6620222B75292C692E736570617261746F7241667465723E302626692E7365';
wwv_flow_imp.g_varchar2_table(26) := '70617261746F7241667465723C75262628652B312925692E736570617261746F7241667465723D3D3D302626653C752D312626742E636C6173734C6973742E6164642822636F6D2D63656D736D2D6F74705F5F626F782D2D67617022292C742E61646445';
wwv_flow_imp.g_varchar2_table(27) := '76656E744C697374656E65722822666F637573222C66756E6374696F6E28297B653E662E6C656E6774683F7928662E6C656E677468293A742E73656C65637428297D292C742E6164644576656E744C697374656E65722822636C69636B222C66756E6374';
wwv_flow_imp.g_varchar2_table(28) := '696F6E28297B742E73656C65637428297D292C742E6164644576656E744C697374656E65722822696E707574222C66756E6374696F6E286E297B76617220613D742E76616C75652E73706C69742822E280A222292E6A6F696E282222293B696628222221';
wwv_flow_imp.g_varchar2_table(29) := '3D3D742E76616C7565297B76617220693D672861293B696628692E6C656E677468297B69662822696E7365727454657874223D3D3D6E2E696E707574547970652626766F69642030213D3D665B655D2626692E6C656E6774683E31297B76617220723D69';
wwv_flow_imp.g_varchar2_table(30) := '2E696E6465784F6628665B655D293B723E2D312626692E73706C69636528722C31292C693D5B695B692E6C656E6774682D315D5D7D4128652C69297D656C7365206828297D656C736520452865297D292C742E6164644576656E744C697374656E657228';
wwv_flow_imp.g_varchar2_table(31) := '226B6579646F776E222C66756E6374696F6E2874297B73776974636828742E6B6579297B63617365224261636B7370616365223A742E70726576656E7444656661756C7428292C653C662E6C656E6774683F28452865292C79286529293A653E30262628';
wwv_flow_imp.g_varchar2_table(32) := '4528652D31292C7928652D3129293B627265616B3B636173652244656C657465223A742E70726576656E7444656661756C7428292C653C662E6C656E677468262628452865292C79286529293B627265616B3B63617365224172726F774C656674223A74';
wwv_flow_imp.g_varchar2_table(33) := '2E70726576656E7444656661756C7428292C7928652D31293B627265616B3B63617365224172726F775269676874223A742E70726576656E7444656661756C7428292C7928652B31293B627265616B3B6361736522486F6D65223A742E70726576656E74';
wwv_flow_imp.g_varchar2_table(34) := '44656661756C7428292C792830293B627265616B3B6361736522456E64223A742E70726576656E7444656661756C7428292C7928662E6C656E677468297D7D292C742E6164644576656E744C697374656E657228227061737465222C66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(35) := '2874297B696628742E70726576656E7444656661756C7428292C692E616C6C6F775061737465297B766172206E3D742E636C6970626F617264446174617C7C77696E646F772E636C6970626F617264446174612C613D67286E3F6E2E6765744461746128';
wwv_flow_imp.g_varchar2_table(36) := '227465787422293A2222293B612E6C656E67746826264128612E6C656E6774683E3D753F303A652C61297D7D292C747D7D7D7D28617065782C617065782E6A5175657279293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(15987739908271084)
,p_plugin_id=>wwv_flow_imp.id(15967538395161608)
,p_file_name=>'otp-input.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
