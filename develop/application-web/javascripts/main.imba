import 'imba-router'
import State from './controller.imba'

const CodeMirror = require 'codemirror'

console.dir CodeMirror:models

tag FormEditor < form
	prop item
	prop index

	def mount
		@cm = CodeMirror querySelector( 'section > section' ).dom, {
			lineNumbers: true,
			mode: "text"
			}
		@cm.on "change", do |edoc| @item:body = edoc.getValue

	def changeSnipperFile
		@item:filename = @filename.value

	def changeSnipperCode code
		if  @item:code = code:name || '' then @cm.setOption "mode", code:mode || 'text'

	def render
		<self>
			<section>
				<div>
					<label> <input@filename type="text" placeholder="Название файла" :input.changeSnipperFile >
					<i.far.fa-trash-alt :click.deleteSnipperCode( @index )>
					<s>
					<details>
						<summary> @item:code ? @item:code : "Выбрать язык кода"
						<ul>
							<li :click.changeSnipperCode( {} ) > "Auto"
							<li :click.changeSnipperCode( { name: "Perl", mode: 'perl' } )> "Perl"
							<li :click.changeSnipperCode( { name: "JavaScript", mode: "javascript" } )> "JavaScript"
							<li :click.changeSnipperCode( { name: "Java", mode: "clike" } )> "Java"
							<li :click.changeSnipperCode( { name: "CSS", mode: "css" } )> "CSS"
							<li :click.changeSnipperCode( { name: "HTML", mode: "htmlmixed" } )> "HTML"
				<section>


tag CodeEditors < article
	prop snipper default: []

	def setup
		dom:ownerDocument:body.addEventListener 'click', do |e|
			if let el = dom.querySelector('details[open]') then el.removeAttribute 'open'
	def mount
		@snipper = [{}]

	def createSnipperCode
		@snipper.push {}

	def deleteSnipperCode index
		if index && index isa Number then @snipper.splice index, 1

	def countSnippers
		@snipper:length && @snipper.filter( do |item| !!item:body ):length

	def render
		<self .{ 'snippers-' + Number !!@snipper && @snipper:length }>
			<h2>
				<i.fas.fa-laptop-code>
				<span> "Новый кусок кода"
			<section>
				<label> <input@description type="text" placeholder="Описание" >
				for item, index in @snipper
					<FormEditor item=item index=index>
				<div>
					<button.active :click.createSnipperCode > "Добавить"
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