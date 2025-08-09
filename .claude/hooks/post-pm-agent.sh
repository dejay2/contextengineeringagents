#!/bin/bash
# Hook to remind Claude to invoke memory agent after PM agent completes

echo "REMINDER: The PM agent has completed. You must now invoke the memory agent to store the PM context using the Task tool with this prompt:"
echo ""
echo "Task tool → memory agent:"
echo "\"Store PM context from the session that just completed. Include all decisions, requirements, and next steps.\""