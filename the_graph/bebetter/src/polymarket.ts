import { QuestionCreated as QuestionCreatedEvent } from "../generated/Polymarket/Polymarket"
import { QuestionCreated } from "../generated/schema"

export function handleQuestionCreated(event: QuestionCreatedEvent): void {
  let entity = new QuestionCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.Polymarket_id = event.params.id
  entity.question = event.params.question
  entity.timestamp = event.params.timestamp
  entity.createdBy = event.params.createdBy
  entity.creatorImageHash = event.params.creatorImageHash
  entity.totalAmount = event.params.totalAmount
  entity.totalYesAmount = event.params.totalYesAmount
  entity.totalNoAmount = event.params.totalNoAmount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
