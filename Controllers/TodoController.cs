using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using TodoApi.Data;
using TodoApi.Models;

namespace TodoApi.Controllers {

    [Route ("api/[controller]")]
    [ApiController]
    public class TodoController : ControllerBase {
        private readonly TodoContext context;
                public ILogger<TodoController> _logger { get; }


        public TodoController (TodoContext context, ILogger<TodoController> logger) {
            this.context = context;
            this._logger = logger;

            //TODO: remove the statement that adds an item id there are no items in the TodoItems table
            if (context.TodoItems.Count () == 0) {

                context.TodoItems.Add (new TodoItem { Name = "pay bills" });
                context.TodoItems.Add (new TodoItem { Name = "buy milk", IsComplete = true });
                context.TodoItems.Add (new TodoItem { Name = "catch a butterfly" });
                context.TodoItems.Add (new TodoItem { Name = "make the world a better place", IsComplete = true });



                context.SaveChanges ();
            }
        }


        [HttpGet("all", Name="todo_get_all")]
        public ActionResult<List<TodoItem>> GetAll () {
            var allTodoItems = this.context.TodoItems.ToList ();
            return allTodoItems;
        }


        //sample of Http attribute routing - https://docs.microsoft.com/en-ca/aspnet/core/mvc/controllers/routing?view=aspnetcore-2.1#attribute-routing-with-httpverb-attributes
        [HttpGet ("{id}/details", Name = "[controller]_[action]")]    
        public ActionResult<TodoItem> GetTodoById (long id) {
            var todoById = this.context.TodoItems.FirstOrDefault (c => c.Id == id);
            if(todoById == null){
                return NotFound();
            }
            return todoById;
        }





        [HttpGet(Name="[controller]_[action]_async")]
        public async Task<ActionResult<List<TodoItem>>> GetAllAsync() 
        {
            var allTodoItems = await this.context.TodoItems.OrderByDescending(i=>i.Id).ToListAsync();
            return allTodoItems;
        }
        

        [HttpGet("{id}", Name="[controller]_[action]_async")]
        public async Task<ActionResult<TodoItem>> GetTodoItemIdAsync(long id){

            var todoItem = await this.context.TodoItems.FirstOrDefaultAsync(i=>i.Id == id);
            if(todoItem == null){
                return NotFound();
            }
            return todoItem;
        }



        [HttpPost("add", Name="[controller]_[action]")]
        public async Task<IActionResult> CreateTodoItem([FromBody] TodoItem todoItem){
            this.context.TodoItems.Add(todoItem);
            var addItemResult = await this.context.SaveChangesAsync();
            this._logger.LogDebug(JsonConvert.SerializeObject(addItemResult));
            
            
            IActionResult result; //createdAtRouteActionResult = CreatedAtRoute("Todo_GetTodoItemIdAsync", new { id = todoItem.Id }, todoItem);
            
            if(addItemResult > 0){
                // result = CreatedAtRoute("Todo_GetTodoItemIdAsync", new { id = todoItem.Id }, todoItem);
                result = CreatedAtRoute("Todo_GetTodoItemIdAsync_async", new { id = todoItem.Id }, todoItem);

            }
            else{
                result = BadRequest();
            }

            return result;

        }
    

    }
}