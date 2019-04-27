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
		querySelector( 'section > section' ).dom:textContent = ''
		@cm = CodeMirror querySelector( 'section > section' ).dom, {
			lineNumbers: true,
			mode: "text",
			value: @item:body || ''
			}
		@cm.on "change", do |edoc| @timeout = clearTimeout( @timeout ) || setTimeout( &, 300 ) do
			State.getMimeType( @item:body = edoc.getValue ).then do |response|
				console.log response
				Imba.commit

	def changeSnipperName
		@item:filename = @filename.value

	def changeSnipperCode code
		if  @item:code = code:name || '' then @cm.setOption "mode", code:mode || 'text'

	def createSnipperHref
		@timeout = clearTimeout( @timeout ) || setTimeout( &, 300 ) do
			@href.dom:validity:valid && window.fetch( @href.value, { mode: 'cors' } ).then do |response|
				response.text.then do|text| @cm.setValue @item:body = "{ @item:body || '' }\n{ text }"

	def createSnipperFile e
		let reader = FileReader.new
		reader:onload = do|file| @cm.setValue @item:body = "{ @item:body || '' }\n{ file:target:result }"
		Array.from e.target.dom:files, do |item| reader.readAsText item

	def render
		<self>
			<section>
				<div>
					<label> <input@filename type="text" placeholder="Название файла" :input.changeSnipperName>
					<label>
						<input@href type="url" placeholder="Загрузить по ссылке" :input.createSnipperHref>
						<i.fas.fa-link>
					<label title="Загрузить файлом">
						<input@file type="file" accept=".js,.json,.pl,.pm,.css,.html" :change.createSnipperFile>
						<i.fas.fa-download>
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

	def saveSnippers
		!!countSnippers && State.createSnipper { body: @snipper, description: @description.value  }

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
					<button .active=!!countSnippers :click.saveSnippers > "Сохранить"

tag CodeMirrorViwer
	prop value
	prop mode
	prop strings

	def mount
		dom:textContent = ''
		@cm = CodeMirror dom, { readOnly: true, lineNumbers: true, value: @value, mode: @mode || 'text' }

	def render
		<self>

tag CodeViewer < article

	def render
		<self>
			<h2>
				<i.fas.fa-file-code>
				<span> State.current ? State.current:description : "Фрагменты кода загружаются"
			if !State.current then <div>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
			else
				<dl> for item, index in State.current:body
					<dt> item:filename
					<dd> <CodeMirrorViwer value=item:body mode=item:model >

tag Pagination < span

	def previosPage
		if State.page then State.page = State.page - 1

	def nextPage
		if State.page < State.pages then State.page = State.page + 1

	def render
		<self>
			<a :click.previosPage> <i.fas.fa-sort-down>
			<span>
				<span> "{ State.page } из { State.pages }"
			<a :click.nextPage> <i.fas.fa-sort-up>

tag ListCode < section

	def selectCurrent item
		if State.current = item:body then router.go "/view/{ item:id }"

	def render
		<self>
			if State.counter > State.limit then <Pagination>

			<h2>
				<i.fas.fa-code>
				<span> "Все фрагменты"
			if State.counter isa Number && !State.counter then <section> <dl>
				<dt> <i.fas.fa-info-circle>
				<dd> "Данных для просмотра пока еще нет."
			else if !State.pagelist then <div>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
			else
				<ul> for item, index in State.pagelist
					<li :click.selectCurrent( item )>
						<a> "{ item:body:description } / { item:body:body:length } фрагментов"
						<CodeMirrorViwer value=item:body:body[0]:body mode=item:body:body[0]:code strings=10>

			if State.counter > State.limit then <Pagination>


export tag Main < main
	def render
		<self>
			<CodeEditors route="/code">
			<CodeViewer route="/view/:id">
			<ListCode route="/">