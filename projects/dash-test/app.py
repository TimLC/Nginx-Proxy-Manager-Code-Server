from dash import Dash, html

app = Dash(__name__,
            requests_pathname_prefix="/proxy/8050/"
            )

app.layout = html.Div([
    html.H1("Hello Dash")
])

if __name__ == "__main__":
    app.run_server(host="0.0.0.0", port=8050)
