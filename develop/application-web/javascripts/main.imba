
import 'imba-router'

tag CodeEditor < article
	def render
		<self>
			<h2>
				<i.fas.fa-laptop-code>
				<span> "Новый кусок кода"

tag CodeViewer < article
	def render
		<self>
			<h2>
				<i.fas.fa-file-code>
				<span> "Название"

tag ListCode < section
	def render
		<self>
			<h2>
				<i.fas.fa-code>
				<span> "Все фрагменты"


export tag Main < main
	def render
		<self>
			<CodeEditor route="/code">
			<CodeViewer route="/view/:id">
			<ListCode route="/">