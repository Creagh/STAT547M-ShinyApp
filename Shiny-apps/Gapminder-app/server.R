library(ggplot2)

gDat <- read.delim(file = "./data/gapminder.tsv") 

shinyServer(function(input, output) {
	
	# Drop-down selection box generated from Gapminder dataset
	output$choose_country <- renderUI({
		# check to see if multiple countries is selected
		if(input$multiple) {
			title = "Countries:"
		} else {
			title = "Country:"
		}
		selectInput("country_from_gapminder", title, multiple = input$multiple, as.list(levels(gDat$country), 
																																										selected = levels(gDat$country)[1]))
	})
	
	country_data  <- reactive({
		if(is.null(input$country_from_gapminder)) {
			return(NULL)
		}
		subset(gDat, country %in% input$country_from_gapminder & year >= input$year_range[1] & year <= input$year_range[2] )
	})
	
	output$gapminder_table <- renderTable({ 
		country_data()
	})
	
	output$output_country <- renderText({
		c("Countries selected:", paste(input$country_from_gapminder, collapse = ", "))
	})
	
	output$ggplot_gdppc_vs_country <- renderPlot({
		if(is.null(country_data())) {
			return(NULL)
		}
		y <- input$response
		p <- ggplot(country_data(), aes_string(x = "year", y = y))
		
		# check to see if multiple plots selected
		if(input$multiple) {
			# check to see if facetting selected
			if(input$facet) {
				p <- p + facet_wrap(~country) + ggtitle(paste(y, "by Year")) + geom_point(aes(color = country))
				# check to see if smoothing selected
				if(input$smooth) {
					p + geom_smooth(se = FALSE, aes(color = country))
				} else {
					p + geom_line(aes(color = country))
				}
			# no facetting selected
			} else {
				p <- p + ggtitle(paste(y, "by Year")) + geom_point(aes(color = country))
				# check to see if smoothing selected
				if(input$smooth) {
					p + geom_smooth(se = FALSE, aes(color = country))
				} else {
					p + geom_line(aes(color = country))
				}		
			}
		# only single plot selected	
		} else {
			p <- p + ggtitle(paste(y, "by Year for", country_data()$country)) + geom_point()
			# check to see if smoothing selected
			if(input$smooth) {
				p + geom_smooth(se = FALSE, colour = "black")
			} else {
				p + geom_line()
			}
		}

	})
	
	output$lmspline_plot <- renderPlot({
		if(is.null(country_data())) {
			return(NULL)
		}
		library(plyr)
		#devtools::install_github("Creagh/linearspline")
		#libarary(linearspline)
		
		lmspline <- function(x, y, nknots = 1, na.rm = FALSE) {
			
			# Check to see that nknots is a numeric value
			if(!is.numeric(nknots)) {
				stop('The number of knots must be a numeric value.')
				
				# Check to see that nknots is a positive integer 
			} else if(nknots%%1 != 0 || nknots <= 0) {
				stop('The number of knots must be a positive integer.')
			}
			
			# Default: Choose the knots as evenly spaced quantiles of the data
			knots <- quantile(x, (1:nknots) / (nknots + 1), na.rm = na.rm)
			
			# Create the matrix of covariates to pass to the lm function
			m <- create.cov(x, knots)
			
			# Calculate the spline regression function on the covariate matrix using the base R lm function
			fit <- lm(y ~ m)
			
			# Return the fitted function and the knots in a list
			return(list(fit = fit, knots = knots))
		}
		
		create.cov <- function(x, knots) {
			nknots <- length(knots)
			
			# Begin by initializing a matrix of zeroes with the apporpriate dimensions
			m <- matrix(0, nrow = length(x), ncol = nknots + 1)
			
			# Fill the covariate matrix with the appropriate values based on the spline function
			m[,1] <- x
			for(i in 1:nknots) {
				m[, i+1] <- pmax(0, x - knots[i])
			}
			return(m)
		}
		
		pred.spline <- function(x, lspline) {
			nknots  <- length(lspline$knots)
			fit <- lspline$fit
			knots <- lspline$knots
			
			y = coef(fit)[1] + coef(fit)[2] * x
			for(i in 1:nknots) {
				y = y + coef(fit)[i+2] * pmax(0, x - knots[i])
			}
			return(y)
		}
		
		y <- input$response
		ctry <- input$country_from_gapminder
		splines <- dlply(country_data(), ~country, function(x){lmspline(x$year, x[[y]], nknots = input$knots)})
		
		q <- ggplot(country_data(), aes_string(x = "year", y = y)) 
		
		if(input$multiple) {
			stop("The linear splines plotting feature cannot handle multiple countries at one time. Please choose only one country at a time.")
		} else {
			q + geom_point() +
				stat_function(fun = pred.spline, args = list(splines[[ctry]]),colour = 'blue',size = 0.7) +
				ggtitle(paste("Linear Spline of", y, "by Year for", ctry))
		}
	})
	
})