using System;
using System.Collections.Generic;
using System.Linq;
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

            services.AddSwaggerGen (c => c.SwaggerDoc ("v1", new Info { Title = "TodoApi", Version = "v1" }));

            services.AddMvc ().SetCompatibilityVersion (CompatibilityVersion.Version_2_1);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure (IApplicationBuilder app, IHostingEnvironment env) {
            if (env.IsDevelopment ()) {
                app.UseDeveloperExceptionPage ();
            } else {
                app.UseHsts ();
            }

            app.UseSwagger();
            app.UseSwaggerUI(c=>c.SwaggerEndpoint("/swagger/v1/swagger.json", "TodoApi Swagger Ui v1"));

            app.UseHttpsRedirection ();
            app.UseMvc ();
        }
    }
}