/**
 * Adds structured heading numbers, then wraps ASCII runs inside headings so
 * Latin text can use separate heading styling without affecting CJK content.
 */
document.addEventListener("DOMContentLoaded", () => {
	const section = document.querySelector("article > section");
	if (!section) {
		return;
	}

	const headings = Array.from(
		section.querySelectorAll("h1, h2, h3, h4, h5, h6"),
	).filter((heading) => !heading.closest('[role="doc-bibliography"]'));
	const isAscii = (char) => char.charCodeAt(0) <= 0x7f;
	const hasAscii = (text) => Array.from(text).some(isAscii);

	numberHeadings(headings);
	headings.forEach((el) => {
		processNode(el);
	});

	function numberHeadings(elements) {
		if (elements.length === 0) {
			return;
		}

		const counters = [0, 0, 0, 0, 0, 0];
		const baseLevel = Math.min(
			...elements.map((heading) => Number.parseInt(heading.tagName.slice(1), 10)),
		);

		elements.forEach((heading) => {
			const htmlLevel = Number.parseInt(heading.tagName.slice(1), 10);
			const level = htmlLevel - baseLevel + 1;
			if (!Number.isInteger(level) || level < 1 || level > counters.length) {
				return;
			}

			const title = getOriginalTitle(heading);
			heading.dataset.headingTitle = title;
			heading.dataset.headingLevel = String(level);

			for (let index = 0; index < level - 1; index += 1) {
				if (counters[index] === 0) {
					counters[index] = 1;
				}
			}

			counters[level - 1] += 1;
			for (let index = level; index < counters.length; index += 1) {
				counters[index] = 0;
			}

			const number = formatHeadingNumber(counters, level);
			const prefix = level === 1 ? number : `${number} `;
			heading.dataset.headingNumber = number;
			heading.dataset.headingDisplay = `${prefix}${title}`;

			heading.querySelector(".heading-number")?.remove();

			const numberSpan = document.createElement("span");
			numberSpan.className = "heading-number";
			numberSpan.textContent = level === 1 ? number : number;
			heading.insertBefore(numberSpan, heading.firstChild);
		});
	}

	function getOriginalTitle(heading) {
		if (heading.dataset.headingTitle) {
			return heading.dataset.headingTitle;
		}

		const clone = heading.cloneNode(true);
		clone.querySelector(".heading-number")?.remove();
		return clone.textContent.trim();
	}

	function formatHeadingNumber(counters, level) {
		if (level === 1) {
			return `${toChineseOrdinal(counters[0])}\u3001`;
		}

		return counters.slice(0, level).join(".");
	}

	function toChineseOrdinal(value) {
		const digits = [
			"",
			"\u4e00",
			"\u4e8c",
			"\u4e09",
			"\u56db",
			"\u4e94",
			"\u516d",
			"\u4e03",
			"\u516b",
			"\u4e5d",
		];

		if (value <= 0) {
			return "";
		}
		if (value < 10) {
			return digits[value];
		}
		if (value === 10) {
			return "\u5341";
		}
		if (value < 20) {
			return `\u5341${digits[value - 10]}`;
		}
		if (value < 100) {
			const tens = Math.floor(value / 10);
			const ones = value % 10;
			return `${digits[tens]}\u5341${ones === 0 ? "" : digits[ones]}`;
		}

		return String(value);
	}

	function processNode(node) {
		if (node.nodeType === 3) {
			// Node type 3 is a text node.
			const text = node.nodeValue ?? "";

			// Only split text nodes that contain ASCII characters.
			if (hasAscii(text)) {
				const fragment = document.createDocumentFragment();
				let lastIndex = 0;
				let index = 0;

				while (index < text.length) {
					if (!isAscii(text[index])) {
						index += 1;
						continue;
					}

					if (index > lastIndex) {
						fragment.appendChild(
							document.createTextNode(text.substring(lastIndex, index)),
						);
					}

					let endIndex = index + 1;
					while (endIndex < text.length && isAscii(text[endIndex])) {
						endIndex += 1;
					}

					const span = document.createElement("span");
					span.className = "heading-en";
					span.textContent = text.substring(index, endIndex);
					fragment.appendChild(span);

					lastIndex = endIndex;
					index = endIndex;
				}

				// Append any remaining non-ASCII text after the last ASCII run.
				if (lastIndex < text.length) {
					fragment.appendChild(
						document.createTextNode(text.substring(lastIndex)),
					);
				}

				// Replace the original text node with the mixed text/span fragment.
				node.parentNode.replaceChild(fragment, node);
			}
		} else if (node.nodeType === 1) {
			if (node.classList.contains("heading-number")) {
				return;
			}

			// Node type 1 is an element node, such as an anchor inside a heading.
			Array.from(node.childNodes).forEach(processNode);
		}
	}
});
