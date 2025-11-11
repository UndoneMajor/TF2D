# 🌐 GitHub Pages Setup Guide

## Quick Setup (5 minutes)

### Step 1: Push to GitHub
```bash
git add index.html style.css
git commit -m "Add project website"
git push origin main
```

### Step 2: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click **Settings** (top right)
3. Scroll down to **Pages** (left sidebar)
4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/ (root)`
5. Click **Save**

### Step 3: Wait & Access
- GitHub will build your site (takes 1-2 minutes)
- Your site will be live at: `https://yourusername.github.io/2d-fortress/`
- You'll see a green checkmark when it's ready!

---

## Customization

### Update Your GitHub Username
In `index.html`, replace `yourusername` with your actual GitHub username:

```html
<!-- Line 23 -->
<a href="https://github.com/yourusername/2d-fortress" class="btn btn-secondary">View on GitHub</a>

<!-- Line 169 -->
<a href="https://github.com/yourusername/2d-fortress/releases" class="btn btn-large">Download Latest Release</a>

<!-- Footer links -->
<a href="https://github.com/yourusername/2d-fortress">GitHub Repository</a>
```

### Add Screenshots
1. Take screenshots of your game
2. Save them as `screenshot1.png`, `screenshot2.png`, etc.
3. Add an images section to `index.html`:

```html
<section class="screenshots">
    <h2>Screenshots</h2>
    <div class="screenshot-grid">
        <img src="screenshot1.png" alt="Gameplay">
        <img src="screenshot2.png" alt="Classes">
    </div>
</section>
```

### Change Colors
Edit `style.css` variables at the top:

```css
:root {
    --red-team: #d32f2f;      /* RED team color */
    --blue-team: #1976d2;     /* BLUE team color */
    --accent: #ffa726;        /* Accent/highlight color */
}
```

---

## Features of Your Website

✅ **Responsive Design** - Works on mobile, tablet, and desktop  
✅ **Smooth Animations** - Fade-ins, hover effects, scroll animations  
✅ **Modern UI** - Dark theme with glowing effects  
✅ **TF2-Inspired** - RED vs BLUE color scheme  
✅ **Interactive** - Smooth scrolling, animated backgrounds  
✅ **Professional** - Clean layout, easy to navigate  

---

## File Structure

```
2d-fortress/
├── index.html          ← Main website file
├── style.css           ← All styling
├── README.md           ← Project documentation
└── (your game files)
```

---

## Troubleshooting

### Site Not Showing Up?
- Check GitHub Actions tab for build status
- Make sure `index.html` is in the root directory
- Wait 5-10 minutes after enabling Pages

### Want a Custom Domain?
1. Buy a domain (e.g., `tf2d.com`)
2. In GitHub Pages settings, add your custom domain
3. Update your domain's DNS settings (see GitHub docs)

---

## Next Steps

### Enhance Your Website:
1. **Add Gameplay GIFs** - Show action in motion
2. **Video Trailer** - Embed a YouTube gameplay video
3. **Changelog** - Show recent updates
4. **FAQ Section** - Answer common questions
5. **Community Links** - Discord, Twitter, etc.

### Example Video Section:
```html
<section class="video">
    <h2>Watch Gameplay</h2>
    <iframe width="800" height="450" 
        src="https://www.youtube.com/embed/YOUR_VIDEO_ID" 
        frameborder="0" allowfullscreen>
    </iframe>
</section>
```

---

## 🎉 Your Website is Ready!

The website includes:
- Hero section with download buttons
- All 5 classes with stats and weapons
- 8 feature highlights
- Controls guide
- Professional footer
- Smooth animations
- Mobile responsive

**Just push to GitHub and enable Pages!** 🚀

