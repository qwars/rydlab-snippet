
import 'imba-router'

tag CodeEditor < article
	def setup
		dom:ownerDocument:body.addEventListener 'click', do |e|
			if let el = dom.querySelector('details[open]') then el.removeAttribute 'open'

	def render
		<self>
			<h2>
				<i.fas.fa-laptop-code>
				<span> "Новый кусок кода"
			<form>
				<label> <input type="text" placeholder="Описание" >
				<section>
					<div>
						<label> <input type="text" placeholder="Название файла" >
						<s>
						<details>
							<summary> "Выбрать язык кода"
							<ul>
								<li> "Auto"
								<li> "Perl"
								<li> "JavaScript"
								<li> "Java"
								<li> "CSS"
								<li> "HTML"
					<section>
				<section>
					<div>
						<label> <input type="text" placeholder="Название файла" >
						<s>
						<details>
							<summary> "Выбрать язык кода"
							<ul>
								<li> "Auto"
								<li> "Perl"
								<li> "JavaScript"
								<li> "Java"
								<li> "CSS"
								<li> "HTML"
					<section>
				<div>
					<button.active> "Добавить"
					<s>
					<button> "Сохранить"


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
			<Pagination>


export tag Main < main
	def render
		<self>
			<CodeEditor route="/code">
			<CodeViewer route="/view/:id">
			<ListCode route="/">