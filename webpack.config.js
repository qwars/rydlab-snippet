const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const autoprefixer = require('autoprefixer');

module.exports = {
    devServer: {
        historyApiFallback: {
            rewrites: [
                { from: /.*/, to: '/index.html' }
            ]
        },
        before: function(app){
            if( process.argv.includes('--server') ) {
                const command = require('child_process');
                const morbo = 'morbo -m production -w '
                      + __dirname + '/develop/application-restapi/index.pl '
                      + __dirname + '/develop/application-restapi/index.pl '
                command.exec( morbo, function(error,stdout,stderr){
                    console.log('\n[\x1b[5m\x1b[36mWARN\x1b[0m]', 'rest API is working\n')
                })
            }
        }
    },
    context: __dirname + '/develop/application-web',
    plugins: [
        new MiniCssExtractPlugin({
            filename: "styleshets/application.css"
        }),
        new OptimizeCssAssetsPlugin({
            assetNameRegExp: /\.css$/g,
            cssProcessorPluginOptions: {
                preset: ['default', { discardComments: { removeAll: true } }],
            },
            canPrint: true            
        }),
	new CopyWebpackPlugin([
            {
	        cache: true,
	        from: './index.html',
	        to: './index.html'
	    },
	    {
		cache: true,
		from: './favicon.ico',
		to: './favicon.ico'
	    }
	],{ copyUnmodified: true })
    ],    
    module: {
	rules: [
            {
                test: /images.+\.(jpe?g|png|gif|svg|ico)$/i,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        useRelativePath: true
                    }
                }]
            },
            {
	        test: /\.css$/,
                use: [                    
                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            publicPath: '../'
                        }
                    },
                    {
                        loader: 'css-loader'
                    },
                    {
                        loader: 'postcss-loader',
                        options: {
	        	    plugins: [autoprefixer({
	        		browsers: ['ie >= 9', 'last 4 version']
	        	    })],
	        	    sourceMap: true
	        	}
                    }
                ]
	    },
            {
                test: /\.(woff(2)?|ttf|eot|svg)([?#]+\w+)?$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        outputPath: './fonts'
                    }
                }]
            },            
	    {
		test: /\.imba$/,
		loader: 'imba/loader',
	    }
	]
    },
    resolve: {
	extensions: [".imba", ".js", ".json"]
    },
    entry: "./javascripts/index.imba",
    output: {
	path: __dirname + "/public",
	filename: "javascripts/application.js"
    }
}
