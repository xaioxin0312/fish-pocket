import SwiftUI

/// The 探索 page's own icons: a small scene in ink lines with one piece in the spot color, the
/// piece that says what the entry does: the part being plugged in, the node that is lit, the
/// phone in front of the computer. Drawn here rather than taken from SF Symbols, so the page has
/// a look of its own, and in one color for all of them, so the page stays black and white.
///
/// Every icon is drawn on a 38-point grid and scaled to `size`.
struct ExploreGlyph: View {
    enum Kind { case plugins, connectors, capabilities, phoneControl, remote, web, share }

    let kind: Kind
    var size: CGFloat = 38

    var body: some View {
        Canvas { context, canvas in
            context.scaleBy(x: canvas.width / 38, y: canvas.height / 38)
            var pen = Pen(context: context)
            switch kind {
            case .plugins: pen.plugins()
            case .connectors: pen.connectors()
            case .capabilities: pen.capabilities()
            case .phoneControl: pen.phoneControl()
            case .remote: pen.remote()
            case .web: pen.web()
            case .share: pen.share()
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// What the icons are drawn with: ink lines of one weight with round ends, and the spot color.
private struct Pen {
    var context: GraphicsContext
    private let ink = GraphicsContext.Shading.color(Palette.ink)
    private let spot = GraphicsContext.Shading.color(Palette.spot)
    private let line = StrokeStyle(lineWidth: 1.7, lineCap: .round, lineJoin: .round)

    private func stroke(_ path: Path) { context.stroke(path, with: ink, style: line) }
    private func fill(_ path: Path) { context.fill(path, with: spot) }

    private func box(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, _ radius: CGFloat) -> Path {
        Path(roundedRect: CGRect(x: x, y: y, width: width, height: height), cornerRadius: radius, style: .continuous)
    }

    private func dot(_ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
    }

    private func lines(_ points: [(CGFloat, CGFloat)]...) -> Path {
        Path { path in
            for run in points {
                path.addLines(run.map { CGPoint(x: $0.0, y: $0.1) })
            }
        }
    }

    /// A block with a socket in its side, and the piece on its way in.
    mutating func plugins() {
        stroke(Path { path in
            path.move(to: CGPoint(x: 22.5, y: 15.3))
            path.addLine(to: CGPoint(x: 22.5, y: 14))
            path.addArc(tangent1End: CGPoint(x: 22.5, y: 9.5), tangent2End: CGPoint(x: 18, y: 9.5), radius: 4.5)
            path.addLine(to: CGPoint(x: 9, y: 9.5))
            path.addArc(tangent1End: CGPoint(x: 4.5, y: 9.5), tangent2End: CGPoint(x: 4.5, y: 14), radius: 4.5)
            path.addLine(to: CGPoint(x: 4.5, y: 24))
            path.addArc(tangent1End: CGPoint(x: 4.5, y: 28.5), tangent2End: CGPoint(x: 9, y: 28.5), radius: 4.5)
            path.addLine(to: CGPoint(x: 18, y: 28.5))
            path.addArc(tangent1End: CGPoint(x: 22.5, y: 28.5), tangent2End: CGPoint(x: 22.5, y: 24), radius: 4.5)
            path.addLine(to: CGPoint(x: 22.5, y: 22.7))
            path.addArc(center: CGPoint(x: 22.5, y: 19), radius: 3.7, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
        })
        fill(box(25.5, 12.5, 9, 13, 2.8).union(dot(25, 19, 2.8)))
    }

    /// Three services joined up, one of them lit.
    mutating func connectors() {
        stroke(lines([(14.6, 27), (23.4, 27)], [(12.4, 22.8), (16.4, 15.7)], [(25.6, 22.8), (21.6, 15.7)]))
        stroke(dot(10, 27, 4))
        stroke(dot(28, 27, 4))
        fill(dot(19, 11, 4.5))
    }

    /// This phone, and what is on it.
    mutating func capabilities() {
        stroke(box(11, 5, 16, 28, 4.5))
        fill(dot(19, 15.5, 4.5))
        stroke(lines([(15, 24.5), (23, 24.5)], [(15, 28), (20, 28)]))
    }

    /// A phone, and a tap landing on it.
    mutating func phoneControl() {
        stroke(box(8, 5, 15, 27, 4.5))
        context.stroke(dot(23.5, 21, 7.5), with: .color(Palette.spot.opacity(0.45)), lineWidth: 1.5)
        fill(dot(23.5, 21, 3.5))
    }

    /// A computer, and the phone in front of it.
    mutating func remote() {
        stroke(box(6, 8, 23, 16, 3.5))
        stroke(lines([(3.5, 28.5), (20, 28.5)]))
        fill(box(23, 15, 10.5, 18, 3))
    }

    /// A browser window with a page in it.
    mutating func web() {
        stroke(box(5, 7, 28, 24, 5))
        stroke(lines([(5, 14.5), (33, 14.5)]))
        context.fill(dot(9.6, 10.9, 1).union(dot(13.2, 10.9, 1)), with: ink)
        fill(box(9.5, 18.5, 9, 8, 2.2))
        stroke(lines([(22.5, 20), (28.5, 20)], [(22.5, 24.5), (26, 24.5)]))
    }

    /// A tray, and what leaves it.
    mutating func share() {
        stroke(Path { path in
            path.move(to: CGPoint(x: 13, y: 17))
            path.addLine(to: CGPoint(x: 11.5, y: 17))
            path.addArc(tangent1End: CGPoint(x: 7.5, y: 17), tangent2End: CGPoint(x: 7.5, y: 21), radius: 4)
            path.addLine(to: CGPoint(x: 7.5, y: 28))
            path.addArc(tangent1End: CGPoint(x: 7.5, y: 32), tangent2End: CGPoint(x: 11.5, y: 32), radius: 4)
            path.addLine(to: CGPoint(x: 26.5, y: 32))
            path.addArc(tangent1End: CGPoint(x: 30.5, y: 32), tangent2End: CGPoint(x: 30.5, y: 28), radius: 4)
            path.addLine(to: CGPoint(x: 30.5, y: 21))
            path.addArc(tangent1End: CGPoint(x: 30.5, y: 17), tangent2End: CGPoint(x: 26.5, y: 17), radius: 4)
            path.addLine(to: CGPoint(x: 25, y: 17))
        })
        stroke(lines([(19, 24.5), (19, 13)]))
        var head = lines([(14, 12), (19, 5.5), (24, 12)])
        head.closeSubpath()
        fill(head)
        context.stroke(head, with: spot, style: line)
    }
}
