const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const htmlContent = fs.readFileSync(path.resolve(__dirname, '../../index.html'), 'utf8');

describe('Accessibility', () => {
  let doc;

  beforeAll(() => {
    const dom = new JSDOM(htmlContent);
    doc = dom.window.document;
  });

  test('page has lang attribute on html element', () => {
    const html = doc.querySelector('html');
    expect(html.getAttribute('lang')).toBeTruthy();
  });

  test('all images have alt attributes', () => {
    const images = doc.querySelectorAll('img');
    images.forEach(img => {
      expect(img.hasAttribute('alt')).toBe(true);
    });
  });

  test('page has a logical heading hierarchy', () => {
    const headings = doc.querySelectorAll('h1, h2, h3, h4, h5, h6');
    const levels = Array.from(headings).map(h => parseInt(h.tagName[1]));

    // First heading should be h1
    expect(levels[0]).toBe(1);

    // No heading should skip more than one level
    for (let i = 1; i < levels.length; i++) {
      const jump = levels[i] - levels[i - 1];
      expect(jump).toBeLessThanOrEqual(1);
    }
  });

  test('exactly one h1 on the page', () => {
    const h1s = doc.querySelectorAll('h1');
    expect(h1s.length).toBe(1);
  });

  test('form inputs have associated labels', () => {
    const inputs = doc.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
      const id = input.getAttribute('id');
      const hasLabel = !!(id && doc.querySelector(`label[for="${id}"]`));
      const hasAriaLabel = input.hasAttribute('aria-label');
      const hasAriaLabelledBy = input.hasAttribute('aria-labelledby');
      const isWrappedInLabel = input.closest('label') !== null;
      const isHidden = input.getAttribute('type') === 'hidden';

      if (!isHidden) {
        expect(hasLabel || hasAriaLabel || hasAriaLabelledBy || isWrappedInLabel).toBe(true);
      }
    });
  });

  test('buttons have accessible text', () => {
    const buttons = doc.querySelectorAll('button');
    buttons.forEach(btn => {
      const hasText = btn.textContent.trim().length > 0;
      const hasAriaLabel = btn.hasAttribute('aria-label');
      const hasTitle = btn.hasAttribute('title');
      expect(hasText || hasAriaLabel || hasTitle).toBe(true);
    });
  });

  test('links have accessible text', () => {
    const links = doc.querySelectorAll('a');
    links.forEach(link => {
      const hasText = link.textContent.trim().length > 0;
      const hasAriaLabel = link.hasAttribute('aria-label');
      expect(hasText || hasAriaLabel).toBe(true);
    });
  });

  test('page uses semantic HTML elements', () => {
    expect(doc.querySelector('header')).not.toBeNull();
    expect(doc.querySelector('main')).not.toBeNull();
    expect(doc.querySelector('footer')).not.toBeNull();
  });

  test('table has thead for column headers', () => {
    const table = doc.querySelector('table');
    expect(table).not.toBeNull();
    const thead = table.querySelector('thead');
    expect(thead).not.toBeNull();
    const ths = thead.querySelectorAll('th');
    expect(ths.length).toBeGreaterThan(0);
  });

  test('interactive elements are keyboard accessible (use native elements)', () => {
    // Buttons should be actual <button> elements
    const buttons = doc.querySelectorAll('button');
    expect(buttons.length).toBeGreaterThan(0);

    // Slider should be an <input type="range">
    const slider = doc.querySelector('input[type="range"]');
    expect(slider).not.toBeNull();
  });

  test('no empty links', () => {
    const links = doc.querySelectorAll('a');
    links.forEach(link => {
      expect(link.getAttribute('href')).toBeTruthy();
    });
  });

  test('all links have valid href values', () => {
    const links = doc.querySelectorAll('a[href]');
    links.forEach(link => {
      const href = link.getAttribute('href');
      expect(href).not.toBe('#');
      expect(href).not.toBe('');
      expect(href).not.toBe('javascript:void(0)');
    });
  });

  test('color contrast: CSS variables define distinct dark/light values', () => {
    const style = doc.querySelector('style').textContent;

    // Verify key color variables exist for contrast
    expect(style).toContain('--text-primary');
    expect(style).toContain('--text-secondary');
    expect(style).toContain('--white');
    expect(style).toContain('--cream');
  });

  test('text is not too small (no font-size below 0.6rem)', () => {
    const style = doc.querySelector('style').textContent;
    const fontSizes = style.match(/font-size:\s*([\d.]+)rem/g) || [];
    fontSizes.forEach(declaration => {
      const value = parseFloat(declaration.match(/([\d.]+)rem/)[1]);
      expect(value).toBeGreaterThanOrEqual(0.6);
    });
  });
});

describe('Accessibility — axe-core', () => {
  test('passes axe-core automated checks', async () => {
    const { JSDOM } = require('jsdom');
    const axe = require('axe-core');

    const dom = new JSDOM(htmlContent, {
      runScripts: 'dangerously',
      resources: 'usable',
      pretendToBeVisual: true,
    });

    // Wait for scripts to execute
    await new Promise(resolve => setTimeout(resolve, 500));

    const document = dom.window.document;

    // Run axe on the document
    const results = await axe.run(document.documentElement, {
      rules: {
        // Disable rules that don't apply well to jsdom
        'color-contrast': { enabled: false },
        'document-title': { enabled: true },
        'html-has-lang': { enabled: true },
        'landmark-one-main': { enabled: true },
        'page-has-heading-one': { enabled: true },
      },
    });

    const violations = results.violations.filter(v => v.impact === 'critical' || v.impact === 'serious');

    if (violations.length > 0) {
      const summary = violations.map(v =>
        `[${v.impact}] ${v.id}: ${v.description}\n  ${v.nodes.map(n => n.html).join('\n  ')}`
      ).join('\n\n');
      throw new Error(`Accessibility violations:\n${summary}`);
    }
  });
});
