/**
 * Shows a circular reading-progress button that scrolls back to the top.
 */
(() => {
	function createButton() {
		const button = document.createElement("button");
		button.id = "back-to-top";
		button.className = "back-to-top-btn reading-progress-btn";
		button.type = "button";
		button.setAttribute("aria-label", "返回顶部");
		button.innerHTML =
			'<svg aria-hidden="true" viewBox="0 0 48 48" class="reading-progress-icon"><circle class="reading-progress-track" cx="24" cy="24" r="19" pathLength="100"></circle><circle class="reading-progress-ring" cx="24" cy="24" r="19" pathLength="100"></circle><path class="reading-progress-arrow" d="M24 31V18"></path><path class="reading-progress-arrow" d="m17.5 24.5 6.5-6.5 6.5 6.5"></path></svg>';

		button.addEventListener("click", () => {
			window.scrollTo({ top: 0, behavior: "smooth" });
		});

		return button;
	}

	function init() {
		const button = createButton();
		const ring = button.querySelector(".reading-progress-ring");
		document.body.appendChild(button);

		function updateProgress() {
			const maxScroll = Math.max(
				1,
				document.documentElement.scrollHeight - window.innerHeight,
			);
			const progress = Math.min(100, Math.max(0, (window.scrollY / maxScroll) * 100));

			ring.style.strokeDashoffset = `${100 - progress}`;
			button.style.setProperty("--reading-progress", `${progress}%`);
			button.setAttribute("aria-label", `返回顶部，已阅读 ${Math.round(progress)}%`);
		}

		updateProgress();
		window.addEventListener("scroll", updateProgress, { passive: true });
		window.addEventListener("resize", updateProgress);
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
