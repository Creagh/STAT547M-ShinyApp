shinyUI(fluidPage(theme = "bootstrap.css",
	titlePanel("Gapminder Shiny app"),
	em("by Creagh Brierclife"),
	br(),
	br(),
	
	sidebarLayout(
		sidebarPanel(
			h5("Select country and range of years."),
			hr(),
			uiOutput("choose_country"),
			br(),
			p(checkboxInput("multiple", label = "Multiple countries", value = FALSE), align = "left", style = "margin-left:20px"),
			p(checkboxInput("facet", label = "Facet by country", value = FALSE), align = "left", style = "margin-left:20px"),
			hr(),
			selectInput("response", label = "Response Variable:", 
									choices = list("GDP per Capita" = "gdpPercap", "Life Expectancy" = "lifeExp",  "Population" = "pop"), 
									selected = "gdpPercap"),
			hr(),
			sliderInput("year_range", label = "Range of years:", min = 1952, max = 2007, value = c(1955, 2005), 
									format = "####"),
			hr(),
			img(src = "ubc_logo.png", height = "100", style = "margin-left:30%")
			),
		
		mainPanel(h4(textOutput("output_country"), align = "center"),
							tabsetPanel(
								tabPanel("Plot",
												 p(checkboxInput("smooth", label = "Smoothing", value = FALSE), align = "center"),
												 plotOutput("ggplot_gdppc_vs_country")),
								tabPanel("Data", tableOutput("gapminder_table")),
								tabPanel("Linear Spline", 
												 sliderInput("knots", label = "Number of Knots", min = 1, max = 9, value = 1),
												 hr(),
												 plotOutput("lmspline_plot"))
								)
							)
		)
)
)