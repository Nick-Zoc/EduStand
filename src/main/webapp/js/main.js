/**
 * Shared, reusable JS helpers for EduStand.
 * Only include code here that is generic and used across multiple pages.
 */

(function () {
	// Ensure globals are available for older JSP inline scripts to call
	window.escapeHtml = function (value) {
		return String(value ?? '')
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#39;');
	};

	window.escapeAttribute = function (value) {
		return window.escapeHtml(value);
	};

	window.getInitials = function (name) {
		if (!name || !name.trim()) return 'U';
		const parts = name.trim().split(/\s+/);
		if (parts.length === 1) return parts[0].charAt(0).toUpperCase();
		return (parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
	};

	// Generic busy state helper for buttons
	window.setBusy = function (button, busy, busyLabel) {
		if (!button) return;
		if (busy) {
			if (!button.dataset.originalHtml) button.dataset.originalHtml = button.innerHTML;
			button.disabled = true;
			button.innerHTML = '<span class="spinner-border spinner-border-sm me-2" aria-hidden="true"></span>' + (busyLabel || 'Working...');
			return;
		}
		if (button.dataset.originalHtml) {
			button.innerHTML = button.dataset.originalHtml;
			delete button.dataset.originalHtml;
		}
		button.disabled = false;
	};

	function ensureFallbackConfirmModal() {
		let modal = document.getElementById('eduFallbackConfirmModal');
		if (modal) {
			return modal;
		}

		modal = document.createElement('div');
		modal.className = 'modal fade';
		modal.id = 'eduFallbackConfirmModal';
		modal.tabIndex = -1;
		modal.innerHTML = ''
			+ '<div class="modal-dialog modal-dialog-centered">'
			+ '<div class="modal-content border-0 rounded-4 shadow-lg">'
			+ '<div class="modal-header border-bottom border-outline-variant px-4 py-3">'
			+ '<h5 class="modal-title brand-headline fw-bold" id="eduFallbackConfirmTitle">Confirm</h5>'
			+ '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>'
			+ '</div>'
			+ '<div class="modal-body px-4 py-3">'
			+ '<p class="mb-0 text-on-surface-variant" id="eduFallbackConfirmText"></p>'
			+ '</div>'
			+ '<div class="modal-footer border-top border-outline-variant px-4 py-3">'
			+ '<button type="button" class="btn btn-light" data-fallback-confirm="cancel">Cancel</button>'
			+ '<button type="button" class="btn btn-primary btn-primary-edu fw-semibold" data-fallback-confirm="ok">Confirm</button>'
			+ '</div>'
			+ '</div>'
			+ '</div>';
		document.body.appendChild(modal);
		return modal;
	}

	// SweetAlert2 confirm dialog wrapper. Returns Promise<boolean>
	window.showConfirm = function (title, text) {
		// Make sure Swal is available
		if (window.Swal) {
			return Swal.fire({
				title: title || 'Are you sure?',
				text: text || '',
				icon: 'question',
				showCancelButton: true,
				confirmButtonColor: '#007BFF',
				cancelButtonColor: '#6c757d',
				confirmButtonText: 'Yes'
			}).then(result => result.isConfirmed);
		}

		// Fallback to a Bootstrap modal if SweetAlert2 is unavailable.
		if (window.bootstrap && bootstrap.Modal) {
			const modal = ensureFallbackConfirmModal();
			modal.querySelector('#eduFallbackConfirmTitle').textContent = title || 'Are you sure?';
			modal.querySelector('#eduFallbackConfirmText').textContent = text || '';

			return new Promise((resolve) => {
				const modalInstance = bootstrap.Modal.getOrCreateInstance(modal, { backdrop: 'static', keyboard: false });
				const cleanup = () => {
					modal.removeEventListener('click', handleClick);
					modal.removeEventListener('hidden.bs.modal', handleHidden);
				};
				const handleClick = (event) => {
					const action = event.target && event.target.getAttribute('data-fallback-confirm');
					if (!action) return;
					cleanup();
					resolve(action === 'ok');
					modalInstance.hide();
				};
				const handleHidden = () => {
					cleanup();
					resolve(false);
				};
				modal.addEventListener('click', handleClick);
				modal.addEventListener('hidden.bs.modal', handleHidden, { once: true });
				modalInstance.show();
			});
		}

		return Promise.resolve(true);
	};

	// Toastify wrapper: type = 'success'|'error'|'info'|'warning'
	window.showToast = function (type, message, duration = 3500) {
		const bg = type === 'success' ? '#198754' : type === 'error' ? '#dc3545' : type === 'warning' ? '#f59e0b' : '#0d6efd';
		if (window.Toastify) {
			Toastify({
				text: message || '',
				duration: duration,
				close: true,
				gravity: 'top',
				position: 'right',
				style: { background: bg, color: '#fff', boxShadow: '0 6px 18px rgba(15,23,42,0.12)' }
			}).showToast();
			return;
		}

		// Fallback: lightweight non-native toast.
		try { console.log(type, message); } catch (e) { }
		const toast = document.createElement('div');
		toast.className = 'toast align-items-center text-white border-0 show';
		toast.setAttribute('role', 'status');
		toast.setAttribute('aria-live', 'polite');
		toast.style.position = 'fixed';
		toast.style.top = '1rem';
		toast.style.right = '1rem';
		toast.style.zIndex = '1080';
		toast.style.background = bg;
		toast.innerHTML = '<div class="d-flex"><div class="toast-body">' + window.escapeHtml(message || '') + '</div><button type="button" class="btn-close btn-close-white me-2 m-auto" aria-label="Close"></button></div>';
		toast.querySelector('button').addEventListener('click', () => toast.remove());
		document.body.appendChild(toast);
		window.setTimeout(() => {
			if (toast.isConnected) toast.remove();
		}, duration);
	};

	// Generic page alert wrapper for backward compatibility with inline JSP scripts.
	// Shows a toast and also updates any visible page alert container for accessibility.
	window.showAlert = function (type, message) {
		// Map legacy 'danger' to 'error'
		const toastType = (type === 'danger') ? 'error' : type || 'info';
		window.showToast(toastType, message || '');

		// Try to find a sensible page alert container to update for screen readers.
		const selectors = ['#pageAlert', '#usersAlertContainer', '#requestsAlertContainer', '.page-alert', '.edu-page-alert'];
		let container = null;
		for (const s of selectors) {
			container = document.querySelector(s);
			if (container) break;
		}

		if (container) {
			const alertClass = (type === 'danger') ? 'danger' : (type || 'info');
			container.innerHTML = '<div class="alert alert-' + alertClass + ' border-0 rounded-0 m-0" role="alert">' + window.escapeHtml(message || '') + '</div>';
		}
	};

	// Generic POST helper that sends application/x-www-form-urlencoded and returns parsed JSON or null
	window.postFormData = async function (url, formData, options = {}) {
		try {
			const response = await fetch(url, {
				method: 'POST',
				headers: Object.assign({ 'X-Requested-With': 'XMLHttpRequest', 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' }, options.headers || {}),
				body: formData
			});

			if (!response.ok) {
				window.showToast('error', 'Request failed. Please try again.');
				return null;
			}

			return await response.json();
		} catch (err) {
			window.showToast('error', 'Network error. Check your connection and retry.');
			return null;
		}
	};

})();