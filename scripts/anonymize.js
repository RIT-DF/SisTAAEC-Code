// scripts/anonymize.js
// JS executado no Playwright antes de cada screenshot para mascarar dados pessoais.
// Estratégia:
//   1. Walk no DOM: substitui texto, value de inputs editáveis, placeholders, atributos
//   2. Inputs disabled: clona o nó (React perde o fiber) e substitui o value
//   3. Pos-processamento por label: numeral 11 → 99 no campo "Numeral do grupo"
//   4. Listas sensíveis (/grupos, /admin/usuarios, /admin/pre-cadastros): blur em containers

(() => {
  const replacements = [
    [/Bruno Carvalho Castro Souza/g, 'Maria da Silva'],
    [/bruno\.souza@rit\.org\.br/g, 'maria.silva@exemplo.org.br'],
    [/86773d7e-38af-4d21-908e-d42664d407ca/g, '00000000-0000-0000-0000-000000000000'],
    [/61992780605/g, '61999990000'],
    [/\b609958-0\b/g, '999999-0'],
    [/JOSÉ DE ANCHIETA \(11\/3º Distrito\)/g, 'GRUPO EXEMPLO (99/Distrito Demo)'],
    [/JOSÉ DE ANCHIETA · 11\/3º Distrito/g, 'GRUPO EXEMPLO · 99/Distrito Demo'],
    [/JOSÉ DE ANCHIETA/g, 'GRUPO EXEMPLO'],
    [/3º Distrito/g, 'Distrito Demo'],
    [/\(11\/Distrito/g, '(99/Distrito'],
    [/LIS DO LAGO/g, 'GRUPO BETA'],
    [/AcampaGELL/g, 'Acampamento Exemplo'],
    [/GEJACAMP/g, 'Acampamento Demo'],
    [/\bHugo\b/g, 'Pedro'],
    [/\bCamila\b/g, 'Joana'],
    [/Felipe Terra/g, 'Pessoa Demo'],
    [/\bGE 11\b/g, 'GE 99'],
    [/\bGE 15\b/g, 'GE 22'],
  ];

  const apply = (t) => { let o = t; for (const [re, sub] of replacements) o = o.replace(re, sub); return o; };

  function setInputValue(node, newVal) {
    const tag = node.tagName.toLowerCase();
    const proto = tag === 'input' ? window.HTMLInputElement : window.HTMLTextAreaElement;
    const setter = Object.getOwnPropertyDescriptor(proto.prototype, 'value')?.set;
    if (setter) {
      setter.call(node, newVal);
      node.dispatchEvent(new Event('input', { bubbles: true }));
    } else {
      node.value = newVal;
    }
  }

  function replaceDisabledInput(node, newVal) {
    // Clone perde o React fiber, então React não consegue reverter
    const clone = node.cloneNode(true);
    clone.value = newVal;
    clone.setAttribute('value', newVal);
    node.parentNode.replaceChild(clone, node);
  }

  function walk(n) {
    if (!n) return;
    if (n.nodeType === 3) {
      const nt = apply(n.nodeValue);
      if (nt !== n.nodeValue) n.nodeValue = nt;
      return;
    }
    if (n.nodeType !== 1) return;
    const tag = n.tagName?.toLowerCase();
    if (tag === 'script' || tag === 'style' || tag === 'noscript') return;

    if (tag === 'input' || tag === 'textarea') {
      if (n.value) {
        const nv = apply(n.value);
        if (nv !== n.value) {
          if (n.disabled || n.readOnly) {
            replaceDisabledInput(n, nv);
            return; // já substituiu o nó, parar walk neste ramo
          }
          setInputValue(n, nv);
        }
      }
      if (n.placeholder) {
        const np = apply(n.placeholder);
        if (np !== n.placeholder) n.placeholder = np;
      }
    }

    ['title', 'alt', 'aria-label'].forEach((a) => {
      const v = n.getAttribute && n.getAttribute(a);
      if (v) {
        const nv = apply(v);
        if (nv !== v) n.setAttribute(a, nv);
      }
    });

    for (const c of Array.from(n.childNodes)) walk(c);
  }

  walk(document.body);

  // Pós: numeral 11 → 99 no campo "Numeral do grupo"
  Array.from(document.querySelectorAll('label, [data-slot="label"], div')).forEach((el) => {
    const txt = el.textContent?.trim() || '';
    if (txt === 'Numeral do grupo') {
      const container = el.closest('div');
      const input = container?.querySelector('input');
      if (input && input.value === '11') {
        if (input.disabled || input.readOnly) replaceDisabledInput(input, '99');
        else setInputValue(input, '99');
      }
    }
  });

  // Listas sensíveis — borrar para preservar privacidade de outros usuários
  const path = location.pathname;
  if (path === '/grupos' || path === '/admin/usuarios' || path === '/admin/pre-cadastros') {
    const main = document.querySelector('main');
    if (main) {
      const candidates = main.querySelectorAll('div, ul, table, tbody');
      candidates.forEach((c) => {
        if (
          c.children.length >= 2 &&
          c.getBoundingClientRect().height > 200 &&
          (c.tagName === 'UL' ||
            c.tagName === 'TBODY' ||
            (c.className && (c.className.includes('list') || c.className.includes('grid'))))
        ) {
          c.style.filter = 'blur(8px)';
          c.style.userSelect = 'none';
          c.setAttribute('data-anonimizado', 'true');
        }
      });
    }
  }

  return { ok: true, url: location.pathname };
})();
