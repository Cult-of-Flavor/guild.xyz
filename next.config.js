module.exports = {
  reactStrictMode: true,
  images: {
    domains: ["https://flavor.lol"],
  },
  typescript: {
    // !! WARN !!
    // Dangerously allow production builds to successfully complete even if
    // your project has type errors.
    // !! WARN !!
    ignoreBuildErrors: true,
  },

  webpack(config) {
    config.module.rules.push({
      test: /\.svg$/,
      use: [
        {
          loader: "@svgr/webpack",
          options: {
            icon: true,
            replaceAttrValues: { "#fff": "currentColor" },
          },
        },
      ],
    })

    return config
  },
  images: {
    domains: ["storageapi.fleek.co", "ipfs.fleek.co"],
  },
  async rewrites() {
    return [
      {
        source: "/js/script.js",
        destination: "https://stat.zgen.hu/js/plausible.js",
      },
      {
        source: "/api/event",
        destination: "https://stat.zgen.hu/api/event",
      },
      {
        source: "/datadog-rum-v4.js",
        destination: "https://www.datadoghq-browser-agent.com/datadog-rum-v4.js",
      },
    ]
  },
  async redirects() {
    return [
      {
        source: "/guide",
        destination:
          "https://rogue-face-c95.notion.site/Guild-Guide-d94ae6a089174487b3feb5efe2e05ed3",
        permanent: false,
      },
      {
        source: "/guild/:path*",
        destination: "/:path*",
        permanent: true,
      },
      {
        source: "/protein-community/:path*",
        destination: "/protein/:path*",
        permanent: false,
      },
      {
        source: "/courtside/:path*",
        destination: "/the-krause-house/:path*",
        permanent: false,
      },
      {
        source: "/club-level/:path*",
        destination: "/the-krause-house/:path*",
        permanent: false,
      },
      {
        source: "/upper-level/:path*",
        destination: "/the-krause-house/:path*",
        permanent: false,
      },
      {
        source: "/ticketholder/:path*",
        destination: "/the-krause-house/:path*",
        permanent: false,
      },
    ]
  },
}
