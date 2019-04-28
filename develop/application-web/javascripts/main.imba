import 'imba-router'
import State from './controller.imba'

require 'codemirror/mode/meta'
require 'codemirror/mode/perl/perl'
require 'codemirror/mode/javascript/javascript'
require 'codemirror/mode/clike/clike'
require 'codemirror/mode/css/css'
require 'codemirror/mode/htmlmixed/htmlmixed'

const CodeMirror = require 'codemirror'
const moment = require 'moment'

moment.locale 'ru'

tag FormEditor < form
	prop item
	prop index
	prop modes default: [
		{ name: "Auto", mode: '' },
		CodeMirror.findModeByExtension 'pl'
		CodeMirror.findModeByExtension 'js'
		CodeMirror.findModeByExtension 'java'
		CodeMirror.findModeByExtension 'css'
		CodeMirror.findModeByExtension 'html'
	]

	def mount
		querySelector( 'section > section' ).dom:textContent = ''
		if @filename then @filename.value = ''
		if @href then @href.value = ''
		if @file then @file.value = ''
		@cm = CodeMirror querySelector( 'section > section' ).dom, {
			lineNumbers: true,
			mode: "text",
			value: @item:body || ''
			}
		@cm.on "change", do |edoc| @timeout = clearTimeout( @timeout ) || setTimeout( &, 300 ) do
			@item:body = edoc.getValue
			Imba.commit

	def changeSnipperName
		if @filename.dom:validity:valid && @item:filename = @filename.value then !@item:code && changeSnipperCode CodeMirror.findModeByExtension( @item:filename.split('.').reverse[0] )

	def changeSnipperCode code
		if !code then State.getMimeType( "ext.{ @item:filename.split('.').reverse[0] }" )
			.then do |response| if ( !@item:code || !@item:code:mode ) && response:filename.split('.').reverse[0] == @item:filename.split('.').reverse[0] then render changeSnipperCode response
		else
			@item:code = code
			@cm.setOption "mode", @item:code:mode
			render

	def createSnipperHref
		@href.dom:validity:valid && window.fetch( @href.value ).then do |response|
			changeSnipperName @filename.value = @filename.value || @href.value.split('/').reverse[0]
			response.text.then do|text|
				@cm.setValue @item:body = "{ @item:body || '' }\n{ text }"

	def createSnipperFile e
		let reader = FileReader.new
		reader:onload = do|file|
			@file.value = ''
			@cm.setValue @item:body = "{ @item:body || '' }\n{ file:target:result }"
		Array.from e.target.dom:files, do |item|
			changeSnipperName @filename.value = @filename.value || item:name
			reader.readAsText item

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
						if @item:code && @modes.filter( do |item| item:mode && item:mode == @item:code:mode ):length > 0 then <summary> @item:code:name
						else
							<summary> "Выбрать язык кода"
						<ul> for item in @modes
							<li .active=( @item:code && item:mode == @item:code:mode ) :click.changeSnipperCode( item ) > item:name
				<section>


tag CodeEditors < article
	prop snipper default: [{}]

	def setup
		dom:ownerDocument:body.addEventListener 'click', do |e|
			if let el = dom.querySelector('details[open]') then el.removeAttribute 'open'
	def mount
		@snipper = [{}]

	def createSnipperCode
		@snipper.push {}

	def deleteSnipperCode index
		if index && index isa Number then @snipper.splice index, 1

	def saveSnippers
		!!countSnippers && State.createSnipper( { snippers: @snipper, description: @description.value  } )
			.then do |response| router.go "/view/{ response }"

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
		@cm = CodeMirror dom, { readOnly: true, lineNumbers: true }
		@cm.setOption "mode",  @mode ? @mode:mode : 'text'
		if !@strings then @cm.setValue @value
		else
			@cm.setValue @value.split('\n').slice( 0, 10 ).join('\n')
			@cm.setOption "scrollbarStyle", null

	def render
		<self>

tag CodeViewer < article

	def render
		<self>
			<h2>
				<i.fas.fa-file-code>
				if State.waiting then <span> "Фрагменты кода загружаются"
				else if !State.current then <span> "Фрагменты кода"
				else <span> State.current:description

			if State.waiting then <div>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
			else if !State.current then <dl.info>
				<dt> <i.fas.fa-info-circle>
				<dd> "Данных для просмотра пока еще нет."
			else
				<dl> for item, index in State.current:snippers
					<dt> item:filename
					<dd> <CodeMirrorViwer value=item:body mode=item:code >

tag Pagination < span

	def previosPage
		if State.page then State.page = State.page - 1

	def nextPage
		if State.page < State.pages then State.page = State.page + 1

	def render
		<self>
			<a .active=( State.page > 1 ) :click.previosPage> <i.fas.fa-sort-down>
			<span>
				<span> "{ State.page } из { State.pages }"
			<a .active=( State.page < State.pages ) :click.nextPage> <i.fas.fa-sort-up>

tag ListCode < section

	def selectCurrent item
		if State.current = item:body then router.go "/view/{ item:id }"

	def render
		<self>
			if State.counter > State.limit then <Pagination>

			<h2>
				<i.fas.fa-code>
				<span> "Все фрагменты"
			if State.counter isa Number && !State.counter then <dl.info>
				<dt> <i.fas.fa-info-circle>
				<dd> "Данных для просмотра пока еще нет."
			else if State.waiting then <div>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
				<i.fas.fa-spinner>
			else
				<ul> for item, index in State.pagelist
					<li :click.selectCurrent( item )>
						<a>
							<i.fas.fa-file-code>
							"{ item:body:description } ( { moment( item:created ).fromNow } ), фрагментов: { item:body:snippers:length }"
						<CodeMirrorViwer value=item:body:snippers[0]:body mode=item:body:snippers[0]:code strings=10>

			if State.counter > State.limit then <Pagination>


export tag Main < main
	def render
		<self>
			<CodeEditors route="/code">
			<CodeViewer route="/view/:id">
			<ListCode route="/">