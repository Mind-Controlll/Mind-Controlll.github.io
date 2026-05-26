/**
 * Enhances rendered code blocks with line numbers and a copy button.
 */
document.addEventListener("DOMContentLoaded", () => {
	const codeBlocks = document.querySelectorAll("pre > code");

	const copyText = async (text) => {
		const clipboard = globalThis.navigator?.clipboard;

		if (clipboard?.writeText) {
			try {
				await clipboard.writeText(text);
				return;
			} catch (err) {
				console.warn("Clipboard API failed, falling back to execCommand.", err);
			}
		}

		if (typeof document.execCommand !== "function") {
			throw new Error("No supported clipboard copy method is available");
		}

		const textarea = document.createElement("textarea");
		textarea.value = text;
		textarea.setAttribute("readonly", "");
		textarea.style.position = "fixed";
		textarea.style.top = "0";
		textarea.style.left = "-9999px";
		document.body.appendChild(textarea);
		textarea.select();

		try {
			const copied = document.execCommand("copy");
			if (!copied) throw new Error("execCommand copy returned false");
		} finally {
			textarea.remove();
		}
	};

	codeBlocks.forEach((codeBlock) => {
		const pre = codeBlock.parentElement;

		// ========== Add line numbers ==========
		// Check if already processed
		if (!pre.querySelector(".line-numbers-rows")) {
			// Clone to count lines correctly handling <br>
			const clone = codeBlock.cloneNode(true);
			const brs = clone.querySelectorAll("br");
			brs.forEach((br) => {
				br.replaceWith("\n");
			});

			const text = clone.textContent;
			// Remove trailing newline if it exists to avoid extra line number
			const cleanText = text.replace(/\n$/, "");
			const lineCount = cleanText.split(/\r\n|\r|\n/).length;

			// Create line numbers container
			const rows = document.createElement("span");
			rows.className = "line-numbers-rows";

			for (let i = 1; i <= lineCount; i++) {
				const span = document.createElement("span");
				span.textContent = i;
				rows.appendChild(span);
			}

			// Insert before code block
			pre.insertBefore(rows, codeBlock);
			pre.classList.add("has-line-numbers");
		}

		// ========== Add copy button ==========
		// Check if copy button already exists
		if (pre.querySelector(".copy-button")) return;

		// Create the copy button
		const copyButton = document.createElement("button");
		copyButton.className = "copy-button";
		copyButton.type = "button";
		copyButton.setAttribute("aria-label", "Copy code");
		copyButton.textContent = "Copy";

		// Add click event listener
		copyButton.addEventListener("click", async () => {
			// Clone the code block to handle <br> tags correctly
			const clone = codeBlock.cloneNode(true);

			// Replace <br> tags with newlines
			const brs = clone.querySelectorAll("br");
			brs.forEach((br) => {
				br.replaceWith("\n");
			});

			// Get text content (now with newlines)
			const codeText = clone.textContent;
			const originalText = "Copy";

			try {
				await copyText(codeText);
				// Success feedback
				copyButton.textContent = "Copied!";
				copyButton.classList.add("copied");
				copyButton.classList.remove("error");

				setTimeout(() => {
					copyButton.textContent = originalText;
					copyButton.classList.remove("copied");
				}, 1200);
			} catch (err) {
				console.error("Failed to copy text: ", err);
				copyButton.textContent = "Error";
				copyButton.classList.add("error");
				copyButton.classList.remove("copied");

				setTimeout(() => {
					copyButton.textContent = originalText;
					copyButton.classList.remove("error");
				}, 1200);
			}
		});

		// Make sure pre is positioned relatively so we can absolute position the button
		pre.style.position = "relative";

		// Append button to pre
		pre.appendChild(copyButton);
	});
});
