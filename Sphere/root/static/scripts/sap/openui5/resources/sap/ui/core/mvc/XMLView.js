/*!
 * UI development toolkit for HTML5 (OpenUI5)
 * (c) Copyright 2009-2016 SAP SE or an SAP affiliate company.
 * Licensed under the Apache License, Version 2.0 - see LICENSE.txt.
 */
sap.ui.define(['jquery.sap.global','sap/ui/core/XMLTemplateProcessor','sap/ui/core/library','./View','sap/ui/model/resource/ResourceModel','sap/ui/base/ManagedObject','sap/ui/core/Control','jquery.sap.xml'],function(q,X,l,V,R,M,C){"use strict";var a=l.RenderPrefixes,b=l.mvc.ViewType;var c=V.extend("sap.ui.core.mvc.XMLView",{metadata:{library:"sap.ui.core",specialSettings:{containingView:{type:'sap.ui.core.mvc.XMLView',visibility:'hidden'},xmlNode:{type:'Element',visibility:'hidden'}},designTime:true}});sap.ui.xmlview=function(i,f){return sap.ui.view(i,f,b.XML);};c._sType=b.XML;c.asyncSupport=true;function v(x){if(x.parseError.errorCode!==0){var p=x.parseError;throw new Error("The following problem occurred: XML parse Error for "+p.url+" code: "+p.errorCode+" reason: "+p.reason+" src: "+p.srcText+" line: "+p.line+" linepos: "+p.linepos+" filepos: "+p.filepos);}}function d(s){if(!s){throw new Error("mSettings must be given");}else if(s.viewName&&s.viewContent){throw new Error("View name and view content are given. There is no point in doing this, so please decide.");}else if((s.viewName||s.viewContent)&&s.xmlNode){throw new Error("View name/content AND an XML node are given. There is no point in doing this, so please decide.");}else if(!(s.viewName||s.viewContent)&&!s.xmlNode){throw new Error("Neither view name/content nor an XML node is given. One of them is required.");}}function g(o,s){o.mProperties["viewContent"]=s.viewContent;var x=q.sap.parseXML(s.viewContent);v(x);return x.documentElement;}c.prototype.initViewSettings=function(s){var t=this;function p(){if(!t.isSubView()){X.parseViewAttributes(t._xContent,t,s);}else{delete s.controller;}if((t._resourceBundleName||t._resourceBundleUrl)&&(!s.models||!s.models[t._resourceBundleAlias])){var m=new R({bundleName:t._resourceBundleName,bundleUrl:t._resourceBundleUrl,bundleLocale:t._resourceBundleLocale});t.setModel(m,t._resourceBundleAlias);}t.oAfterRenderingNotifier=new e();t.oAfterRenderingNotifier.addDelegate({onAfterRendering:function(){t.onAfterRenderingBeforeChildren();}});}function f(x){t._xContent=x;}function r(A){if(t.hasPreprocessor("viewxml")){X.enrichTemplateIds(t._xContent,t);return t.runPreprocessor("viewxml",t._xContent,!A);}return t._xContent;}function h(){return t.runPreprocessor("xml",t._xContent).then(f).then(r.bind(t,true)).then(f);}function i(j){return q.sap.loadResource(j,{async:true}).then(function(D){f(D.documentElement);return t._xContent;});}this._oContainingView=s.containingView||this;if(this._oAsyncState){this._oAsyncState.suppressPreserve=true;}d(s);if(s.viewName){var j=q.sap.getResourceName(s.viewName,".view.xml");if(s.async){return i(j).then(h).then(p);}else{f(q.sap.loadResource(j).documentElement);}}else if(s.viewContent){f(g(this,s));}else if(s.xmlNode){f(s.xmlNode);}if(s.async){return h(this._xContent).then(p);}else{f(this.runPreprocessor("xml",this._xContent,true));f(r());p();}};c.prototype.exit=function(){if(this.oAfterRenderingNotifier){this.oAfterRenderingNotifier.destroy();}V.prototype.exit.apply(this,arguments);};c.prototype.onControllerConnected=function(o){var t=this;M.runWithPreprocessors(function(){t._aParsedContent=X.parseTemplate(t._xContent,t);if(t._oAsyncState){delete t._oAsyncState.suppressPreserve;}},{settings:this._fnSettingsPreprocessor});};c.prototype.getControllerName=function(){return this._controllerName;};c.prototype.isSubView=function(){return this._oContainingView!=this;};c.prototype.onAfterRenderingBeforeChildren=function(){if(this._$oldContent.length!==0){var f=this.getAggregation("content");if(f){for(var i=0;i<f.length;i++){var o=f[i].getDomRef()||q.sap.domById(a.Invisible+f[i].getId());if(o){q.sap.byId(a.Dummy+f[i].getId(),this._$oldContent).replaceWith(o);}}}q.sap.byId(a.Dummy+this.getId()).replaceWith(this._$oldContent);}this._$oldContent=undefined;};c.prototype._onChildRerenderedEmpty=function(o,E){q(E).replaceWith('<div id="'+a.Dummy+o.getId()+'" class="sapUiHidden"/>');return true;};c.registerPreprocessor=function(t,p,s,o,S){t=t.toUpperCase();if(c.PreprocessorType[t]){V.registerPreprocessor(c.PreprocessorType[t],p,this.getMetadata().getClass()._sType,s,o,S);}else{q.sap.log.error("Preprocessor could not be registered due to unknown sType \""+t+"\"",this.getMetadata().getName());}};c.PreprocessorType={XML:"xml",VIEWXML:"viewxml",CONTROLS:"controls"};var e=C.extend("sap.ui.core.mvc.XMLAfterRenderingNotifier",{metadata:{library:"sap.ui.core"},renderer:function(r,o){r.write("");}});c.registerPreprocessor("xml","sap.ui.core.util.XMLPreprocessor",true,true);return c;});