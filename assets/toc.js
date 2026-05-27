/**
 * Builds a blog-only table of contents and highlights the current section.
 */
(() => {
	const MIN_HEADINGS = 2;
	const ACTIVE_OFFSET = 96;

	function isBlogArticle() {
		const path = window.location.pathname.replace(/\/+$/, "/");
		return path.startsWith("/Blog/") && path !== "/Blog/";
	}

	function collectHeadings(section) {
		return Array.from(section.querySelectorAll("h2, h3, h4, h5")).filter(
			(heading) => !heading.closest('[role="doc-bibliography"]'),
		);
	}

	function ensureHeadingId(heading, index, usedIds) {
		const fallbackId = `toc-${index + 1}`;
		const baseId = heading.id || fallbackId;
		let id = baseId;
		let suffix = 2;

		while (
			usedIds.has(id) ||
			(document.getElementById(id) && document.getElementById(id) !== heading)
		) {
			id = `${baseId}-${suffix}`;
			suffix += 1;
		}

		heading.id = id;
		usedIds.add(id);
		return id;
	}

	function buildToc(headings) {
		const nav = document.createElement("nav");
		nav.className = "toc-sidebar blog-toc";
		nav.setAttribute("aria-label", "文章目录");

		const title = document.createElement("div");
		title.className = "toc-title";
		title.textContent = "本文目录";

		const list = document.createElement("ol");
		const usedIds = new Set();

		headings.forEach((heading, index) => {
			const id = ensureHeadingId(heading, index, usedIds);
			const item = document.createElement("li");
			const link = document.createElement("a");

			item.classList.add(`toc-${heading.tagName.toLowerCase()}`);
			link.href = `#${id}`;
			link.textContent = heading.textContent.trim();

			item.appendChild(link);
			list.appendChild(item);
		});

		nav.appendChild(title);
		nav.appendChild(list);
		return nav;
	}

	function bindSmoothScroll(nav) {
		nav.addEventListener("click", (event) => {
			const link = event.target.closest("a");
			if (!link || !nav.contains(link)) {
				return;
			}

			const target = document.getElementById(link.hash.slice(1));
			if (!target) {
				return;
			}

			event.preventDefault();
			target.scrollIntoView({ behavior: "smooth", block: "start" });
			history.replaceState(null, "", link.hash);
		});
	}

	function bindScrollSpy(nav, headings) {
		const linksById = new Map(
			Array.from(nav.querySelectorAll("a")).map((link) => [
				link.hash.slice(1),
				link,
			]),
		);
		let ticking = false;

		function setActive(id) {
			nav.querySelector("a.is-active")?.classList.remove("is-active");
			const link = linksById.get(id);
			if (!link) {
				return;
			}
			link.classList.add("is-active");
			link.scrollIntoView({ block: "nearest" });
		}

		function updateActiveHeading() {
			ticking = false;
			let activeHeading = headings[0];

			for (const heading of headings) {
				const top = heading.getBoundingClientRect().top;
				if (top <= ACTIVE_OFFSET) {
					activeHeading = heading;
				} else {
					break;
				}
			}

			setActive(activeHeading.id);
		}

		function requestUpdate() {
			if (ticking) {
				return;
			}
			ticking = true;
			window.requestAnimationFrame(updateActiveHeading);
		}

		updateActiveHeading();
		window.addEventListener("scroll", requestUpdate, { passive: true });
		window.addEventListener("resize", requestUpdate);
	}

	function init() {
		if (!isBlogArticle()) {
			return;
		}

		const section = document.querySelector("article > section");
		if (!section) {
			return;
		}

		const headings = collectHeadings(section);
		if (headings.length < MIN_HEADINGS) {
			return;
		}

		const nav = buildToc(headings);
		document.body.insertBefore(nav, document.querySelector("article"));
		bindSmoothScroll(nav);
		bindScrollSpy(nav, headings);
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
