using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Swashbuckle.AspNetCore.Swagger;
using TodoApi.Data;

//the following 3 are required for NSwag
using NJsonSchema;
using NSwag.AspNetCore;
// using System.Reflection;

namespace TodoApi {
    public class Startup {
        public Startup (IConfiguration configuration) {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices (IServiceCollection services) {

            //registering the added database context to use InMemoryDatabase
            services.AddDbContext<TodoContext> (options =>
                options.UseInMemoryDatabase ("TodoList")
                //TODO: swap the InMemoryDatabase with SqlLite
                //options.UseSqlite (Configuration.GetConnectionString ("DefaultConnection")));
                //TODO: update the appsettings.json with the following
                /*
                  "ConnectionStrings": {"DefaultConnection": "DataSource=app.db" }
                 */

            );

            //Swashbuckle
            // services.AddSwaggerGen (c => {

            //         c.SwaggerDoc ("v1", new Info {
            //             Title = "TodoApi",
            //                 Version = "v1"

            //                 , Description = "Sample API build with .net core 2.1", License = new License {
            //                     Name = "Use under m1k0 Licencing Authority Grant",
            //                         Url = "http://boite.najok.com"
            //                 }, TermsOfService = "google.com", Contact = new Contact {
            //                     Name = "Baba Roga",
            //                         Email = "baba.roga@live.com",
            //                         Url = "https://twitter.com/baba-roga"
            //                 }
            //         });

            //         // Set the comments path for the Swagger JSON and UI.
            //         var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
            //         var xmlPath = Path.Combine (AppContext.BaseDirectory, xmlFile);
            //         c.IncludeXmlComments (xmlPath);

            //     }

            // );

            services.AddSwagger(); //NSwag

            services.AddMvc ().SetCompatibilityVersion (CompatibilityVersion.Version_2_1);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure (IApplicationBuilder app, IHostingEnvironment env) {
            if (env.IsDevelopment ()) {
                app.UseDeveloperExceptionPage ();
            } else {
                app.UseHsts ();
            }

            //Swashbuckle
            // app.UseSwagger ();
            // app.UseSwaggerUI (c => {
            //     c.SwaggerEndpoint ("/swagger/v1/swagger.json", "TodoApi Swagger Ui v1");
            //     c.RoutePrefix = String.Empty;
            // });


            //NSwag
            // Register the Swagger generator and the Swagger UI middlewares
            app.UseSwaggerUi3WithApiExplorer(settings =>
            {
                settings.GeneratorSettings.DefaultPropertyNameHandling = 
                    PropertyNameHandling.CamelCase;
                
            });



            app.UseHttpsRedirection ();
            app.UseMvc ();
        }
    }
}