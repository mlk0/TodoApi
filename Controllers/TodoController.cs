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

    /// <summary>
    /// CRUD operations for the TodoItem
    /// </summary>
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

        /// <summary>
        /// Get all Todo items
        /// </summary>
        /// <returns></returns>
        [HttpGet ("all", Name = "todo_get_all")]
        public ActionResult<List<TodoItem>> GetAll () {
            var allTodoItems = this.context.TodoItems.ToList ();
            return allTodoItems;
        }

        //sample of Http attribute routing - https://docs.microsoft.com/en-ca/aspnet/core/mvc/controllers/routing?view=aspnetcore-2.1#attribute-routing-with-httpverb-attributes
        /// <summary>
        /// Get the details for a TodoItem specified by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet ("{id}/details", Name = "[controller]_[action]")]
        public ActionResult<TodoItem> GetTodoById (long id) {
            var todoById = this.context.TodoItems.FirstOrDefault (c => c.Id == id);
            if (todoById == null) {
                return NotFound ();
            }
            return todoById;
        }

        /// <summary>
        /// Get all Todo items in async mode and soret them in descending order based on their id values
        /// </summary>
        /// <returns></returns>
        [HttpGet (Name = "[controller]_[action]_async")]
        public async Task<ActionResult<List<TodoItem>>> GetAllAsync () {
            var allTodoItems = await this.context.TodoItems.OrderByDescending (i => i.Id).ToListAsync ();
            return allTodoItems;
        }

        /// <summary>
        /// Get TodoItem by id async
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet ("{id}", Name = "[controller]_[action]_async")]
        public async Task<ActionResult<TodoItem>> GetTodoItemIdAsync (long id) {

            var todoItem = await this.context.TodoItems.FirstOrDefaultAsync (i => i.Id == id);
            if (todoItem == null) {
                return NotFound ();
            }
            return todoItem;
        }

        /// <summary>
        /// Creates new TodoItem
        /// </summary>
        /// <remarks>
        /// Sample payload:
        /// {
        /// "name": "milk the cow",
        /// "isComplete": false    
        /// }
        /// </remarks>
        /// <param name="todoItem"></param>
        /// <returns>Newly created Todo item</returns>
        /// <response code="201">Returns the newly created item</response>
        /// <response code="400">If the item = is null</response> 
        [HttpPost ("", Name = "[controller]_[action]")]
        [HttpPost ("add", Name = "[controller]_[action]_add")]
        [ProducesResponseType (201)]
        [ProducesResponseType (400)]
        public async Task<IActionResult> CreateTodoItem ([FromBody] TodoItem todoItem) {
            this.context.TodoItems.Add (todoItem);
            var addItemResult = await this.context.SaveChangesAsync ();
            this._logger.LogDebug (JsonConvert.SerializeObject (addItemResult));

            IActionResult result; //createdAtRouteActionResult = CreatedAtRoute("Todo_GetTodoItemIdAsync", new { id = todoItem.Id }, todoItem);

            if (addItemResult > 0) {
                // result = CreatedAtRoute("Todo_GetTodoItemIdAsync", new { id = todoItem.Id }, todoItem);
                result = CreatedAtRoute ("Todo_GetTodoItemIdAsync_async", new { id = todoItem.Id }, todoItem);

            } else {
                result = BadRequest ();
            }

            return result;

        }

        /// <summary>
        /// Updates the TodoItem for the specified id with the data in the paylaod
        /// </summary>
        /// <param name="id"></param>
        /// <param name="todoItem"></param>
        /// <returns></returns>
        [HttpPut ("{id}")]
        public async Task<IActionResult> UpdateTodoItemAsync (long id, [FromBody] TodoItem todoItem) {
            var item = await this.context.TodoItems.FirstOrDefaultAsync (i => i.Id == id);
            if (item == null) {
                return NotFound ();
            }

            item.IsComplete = todoItem.IsComplete;
            item.Name = todoItem.Name;

            var updateTodoItem = await this.context.SaveChangesAsync ();
            if (updateTodoItem > 0) {
                return NoContent ();
            } else {
                return BadRequest ();
            }

        }

        /// <summary>
        /// Delete TodoItem by the specified id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete ("{id}")]
        public async Task<IActionResult> DeleteTodoItemAsync (long id) {

            if (id <= 0) {
                return BadRequest ();
            }

            var item = await this.context.TodoItems.FirstOrDefaultAsync (i => i.Id == id);
            if (item == null) {
                return NotFound ();
            }

            this.context.TodoItems.Remove (item);
            var deleteItemResult = await this.context.SaveChangesAsync ();
            if (deleteItemResult == 0) {
                return NotFound ();
            }

            return NoContent ();
        }

    }
}