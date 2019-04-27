import 'imba-router'
import State from './controller.imba'

require 'codemirror/mode/meta'
require 'codemirror/mode/perl/perl'
require 'codemirror/mode/javascript/javascript'
require 'codemirror/mode/clike/clike'
require 'codemirror/mode/css/css'
require 'codemirror/mode/htmlmixed/htmlmixed'

const CodeMirror = require 'codemirror'

tag FormEditor < form
	prop item
	prop index

	def mount
		@cm = CodeMirror querySelector( 'section > section' ).dom, {
			lineNumbers: true,
			mode: "text"
			}
		@cm.on "change", do |edoc| @timeout = clearTimeout( @timeout ) || setTimeout( &, 300 ) do
			@item:body = edoc.getValue
			Imba.commit

	def changeSnipperName
		@item:filename = @filename.value

	def changeSnipperCode code
		if  @item:code = code:name || '' then @cm.setOption "mode", code:mode || 'text'

	def createSnipperHref
		@timeout = clearTimeout( @timeout ) || setTimeout( &, 300 ) do
			console.log @href.dom:validity:valid

	def createSnipperFile
		console.log 'file'

	def render
		<self>
			<section>
				<div>
					<label> <input@filename type="text" placeholder="Название файла" :input.changeSnipperName>
					<label>
						<input@href type="url" placeholder="Загрузить по ссылке" :input.createSnipperHref>
						<i.fas.fa-link>
					<label title="Загрузить файлом">
						<input@file type="file">
						<i.fas.fa-download :click.createSnipperFile>
					<i.far.fa-trash-alt :click.deleteSnipperCode( @index )>
					<s>
					<details>
						<summary> !!@item:code && @item:code != 'text' ? @item:code : "Выбрать язык кода"
						<ul>
							<li :click.changeSnipperCode( { mode: 'text' } ) > "Auto"
							<li :click.changeSnipperCode( { name: "Perl", mode: 'perl' } )> "Perl"
							<li :click.changeSnipperCode( { name: "JavaScript", mode: "javascript" } )> "JavaScript"
							<li :click.changeSnipperCode( { name: "Java", mode: "clike" } )> "Java"
							<li :click.changeSnipperCode( { name: "CSS", mode: "css" } )> "CSS"
							<li :click.changeSnipperCode( { name: "HTML", mode: "htmlmixed" } )> "HTML"
				<section>


tag CodeEditors < article
	prop snipper default: [{ code: 'text' }]

	def setup
		dom:ownerDocument:body.addEventListener 'click', do |e|
			if let el = dom.querySelector('details[open]') then el.removeAttribute 'open'
	def mount
		@snipper = [{ code: 'text' }]

	def createSnipperCode
		@snipper.push { code: 'text' }

	def deleteSnipperCode index
		if index && index isa Number then @snipper.splice index, 1

	def countSnippers
		!!@description.value && @snipper:length && @snipper.filter( do |item| !!item:body && !!item:filename && !!item:code ):length

	def render
		<self .{ 'snippers-' + Number !!@snipper && @snipper:length }>
			<h2>
				<i.fas.fa-laptop-code>
				<span> "Добавить код"
			<section>
				<label> <input@description type="text" placeholder="Описание" >
				for item, index in @snipper
					<FormEditor item=item index=index>
				<div>
					<button.active :click.createSnipperCode> "Добавить"
					<s>
					<button .active=!!countSnippers> "Сохранить"


tag CodeViewer < article
	def render
		<self>
			<h2>
				<i.fas.fa-file-code>
				<span> "Название"

tag Pagination < span

	def render
		<self>

tag ListCode < section

	def render
		<self>
			<h2>
				<i.fas.fa-code>
				<span> "Все фрагменты"
			if State.counter isa Number && !State.counter then <section> <dl>
				<dt> <i.fas.fa-info-circle>
				<dd> "Данных для просмотра пока еще нет."
			else if !State.counter then <section>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
			else
				<ul .loading=State.waiting >

			<Pagination>


export tag Main < main
	def render
		<self>
			<CodeEditors route="/code">
			<CodeViewer route="/view/:id">
			<ListCode route="/">