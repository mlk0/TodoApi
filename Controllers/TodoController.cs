using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TodoApi.Data;
using TodoApi.Models;

namespace TodoApi.Controllers {

    [Route ("api/[controller]")]
    [ApiController]
    public class TodoController {
        private readonly TodoContext context;

        public TodoController (TodoContext context) {
            this.context = context;

            //TODO: remove the statement that adds an item id there are no items in the TodoItems table
            if (context.TodoItems.Count () == 0) {

                context.TodoItems.Add (new TodoItem { Name = "pay bills" });
                context.TodoItems.Add (new TodoItem { Name = "buy milk", IsComplete = true });
                context.TodoItems.Add (new TodoItem { Name = "catch a butterfly" });
                context.TodoItems.Add (new TodoItem { Name = "make the world a better place", IsComplete = true });



                context.SaveChanges ();
            }
        }


        [HttpGet]
        public ActionResult<List<TodoItem>> GetAll () {
            var allTodoItems = this.context.TodoItems.ToList ();
            return allTodoItems;
        }


        //sample of Http attribute routing - https://docs.microsoft.com/en-ca/aspnet/core/mvc/controllers/routing?view=aspnetcore-2.1#attribute-routing-with-httpverb-attributes
        [HttpGet ("{id}", Name = "[controller]_[action]")]    
        public ActionResult<TodoItem> GetTodoById (long id) {
            var todoById = this.context.TodoItems.FirstOrDefault (c => c.Id == id);
            return todoById;
        }


        

    }
}