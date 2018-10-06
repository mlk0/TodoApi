using System.Linq;
using Microsoft.AspNetCore.Mvc;
using TodoApi.Data;
using TodoApi.Models;

namespace TodoApi.Controllers {

    [Route("api/[controllerl]")]
    [ApiController]
    public class TodoController {
        private readonly TodoContext context;

        public TodoController (TodoContext context) {
            this.context = context;

            //TODO: remove the statement that adds an item id there are no items in the TodoItems table
            if (context.TodoItems.Count () == 0) {
                context.TodoItems.Add (new TodoItem { Name = "Init Item" });
                context.SaveChanges();
            }


        }

    }
}